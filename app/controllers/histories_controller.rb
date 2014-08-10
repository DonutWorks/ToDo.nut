class HistoriesController < ApplicationController
  def index
    @histories = History.all
  end

  def new
    @history = History.new
    @todos = Todo.all
    @users = User.all

    @projects = current_user.assigned_projects;
  end

  def create
    #referenced_users = params[:history][:description].scan(/\B@(\w+)\b/).flatten!

    @history = History.new(history_params)
    @history.user_id = current_user.id

    @history.transaction do
      associate_history_with_histories!
      associate_history_with_todos!
      associate_history_with_assignees!
      associate_history_with_images!
      @history.save!
    end

    SlackNotifier.instance.notify("히스토리가 추가되었어용 : #{@history.title} (#{Rails.application.routes.url_helpers.history_url(@history)})")
    
    @user = User.find(current_user.id)

    Mail.defaults do
      delivery_method :smtp, :address    => "smtp.gmail.com",
                             :port       => 587,
                             :user_name  => 'donutworks.app@gmail.com',
                             :password   => 'donutwork',
                             :enable_ssl => true
    end

    mail = Mail.new

    mail.from('donutworks.app@gmail.com')
    mail.to(@user.email)
    mail.subject('[Todo.nut] History 에 "' + @history.title + '" 를 등록 했습니다.')

    template = ERB.new(File.read('app/views/mail/newhistory.html.erb')).result(binding)
    mail.html_part  do
      content_type 'text/html; charset=UTF-8'
      body template
    end

    mail.deliver!

    redirect_to root_path

  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def show
    @history = History.find(params[:id])
  end

  def edit
    @history = History.find(params[:id])
    @todos = Todo.all
    @users = User.all
    @projects = current_user.assigned_projects;

  end

  def update
    @history = History.find(params[:id])

    @history.transaction do
      associate_history_with_todos!
      associate_history_with_assignees!
      associate_history_with_images!
      @history.update!(history_params)
    end

    SlackNotifier.instance.notify("히스토리가 수정되었어용 : #{@history.title} (#{Rails.application.routes.url_helpers.history_url(@history)})")
    redirect_to @history

  rescue ActiveRecord::RecordInvalid
    render 'edit'
  end

  def destroy
    @history = History.find(params[:id])
    @history.destroy

    redirect_to root_path
  end

  def list
    from_id = params[:id] || 0
    histories = History.fetch_list_from(from_id, 5)
    render json: histories
  end

  # need move to project#members
  def list_members
    render json: User.all
  end

  private
  def history_params
    params.require(:history).permit(:title, :description, :evented_at, :project_id)
  end

  # metaprogramming?
  def associate_history_with_histories!
    referenced_histories = params[:history][:description].scan(/\B#(\d+)\b/).flatten!

    @history.referencing_histories.destroy_all
    referenced_histories.each do |id|
      @history.history_histories.build(referencing_history_id: id)
    end if referenced_histories != nil
  end

  def associate_history_with_todos!
    referenced_todos = params[:history][:description].scan(/\B&(\d+)\b/).flatten!

    @history.todos.destroy_all
    referenced_todos.each do |id|
      @history.history_todos.build(todo_id: id)
    end if referenced_todos != nil
  end

  def associate_history_with_assignees!
    @history.assignees.destroy_all
    params[:history][:assignee_ids].select!(&:present?).each do |id|
      @history.history_users.build(assignee_id: id)
    end
  end

  def associate_history_with_images!
    @history.images.destroy_all
    params[:history][:images].each do |image|
      @history.images.build(image: image)
    end if params[:history][:images] != nil
  end
end
