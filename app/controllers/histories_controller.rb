class HistoriesController < ApplicationController
  
  before_action :find_project
  respond_to :json
  
  def index
    @histories = History.all
    
  end

  def new
    @history = History.new
    @todos = @project.todos
    @users = @project.assignees
    gon.project_creator = @project.project_owner
    gon.project_title = @project.title
    
  end

  def create
    #referenced_users = params[:history][:description].scan(/\B@(\w+)\b/).flatten!

    @history = History.new(history_params)
    @history.user_id = current_user.id
    @history.project_id = @project.id
    

    @history.transaction do
      associate_history_with_histories!
      associate_history_with_todos!
      associate_history_with_assignees!
      associate_history_with_images!
      @history.save!
    end

    #url_helper -> project_history(@project, @history) is okay?
    SlackNotifier.notify("히스토리가 수정되었어용 : #{@history.title} (#{Rails.application.routes.url_helpers.project_history_url(@project.project_owner, @project.title, @history)})")

    @user = User.find(current_user.id)

    # Mail.defaults do
    #   delivery_method :smtp, :address    => "smtp.gmail.com",
    #                          :port       => 587,
    #                          :user_name  => 'donutworks.app@gmail.com',
    #                          :password   => 'donutwork',
    #                          :enable_ssl => true
    # end

    # mail = Mail.new

    # mail.from('donutworks.app@gmail.com')
    # mail.to(@user.email)
    # mail.subject('[Todo.nut] History 에 "' + @history.title + '" 를 등록 했습니다.')

    # template = ERB.new(File.read('app/views/mail/newhistory.html.erb')).result(binding)
    # mail.html_part  do
    #   content_type 'text/html; charset=UTF-8'
    #   body template
    # end

    # mail.deliver!

    redirect_to project_path(@project.project_owner, @project.title)

  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def show
    @history = @project.histories.find_by_phistory_id(params[:phistory_id])

  end

  def edit
    @history = @project.histories.find_by_phistory_id(params[:phistory_id])
    @todos = @project.todos
    @users = @project.assignees
    gon.project_creator = @project.project_owner
    gon.project_title = @project.title

  end

  def update
    @history = @project.histories.find_by_phistory_id(params[:phistory_id])
    

    @history.transaction do
      associate_history_with_todos!
      associate_history_with_assignees!
      associate_history_with_images!
      @history.update!(history_params)
    end

    #url_helper -> project_history(@project, @history) is okay?
    SlackNotifier.notify("히스토리가 수정되었어용 : #{@history.title} (#{Rails.application.routes.url_helpers.project_history_url(@project.project_owner, @project.title, @history)})")
    redirect_to project_history_path(@project.project_owner, @project.title, @history.phistory_id)

  rescue ActiveRecord::RecordInvalid
    render 'edit'
  end

  def destroy
    @history = @project.histories.find_by_phistory_id(params[:phistory_id])
    @history.destroy

    redirect_to project_path(@project.project_owner, @project.title)
  end

  def list
    from_id = params[:phistory_id] || 0
    histories = @project.histories.fetch_list_from(from_id, 5)
    respond_with histories
  end

  private
  def history_params
    params.require(:history).permit(:title, :description, :evented_at, :project_id)
  end

  def find_project
    @project = current_user.assigned_projects.find_by_title(params[:project_title])
  end

  # metaprogramming?
  def associate_history_with_histories!
    referenced_histories = params[:history][:description].scan(/\B#(\d+)\b/).flatten!

    @history.referencing_histories.destroy_all
    referenced_histories.each do |id|
      referenced_history_id = @project.histories.where(:phistory_id=>id).first.id
      @history.history_histories.build(referencing_history_id: referenced_history_id)
    end if referenced_histories != nil
  end

  def associate_history_with_todos!
    referenced_todos = params[:history][:description].scan(/\B&(\d+)\b/).flatten!

    @history.todos.destroy_all
    referenced_todos.each do |id|
      referenced_todo_id = @project.todos.where(:ptodo_id=>id).first.id
      @history.history_todos.build(todo_id: referenced_todo_id)
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
