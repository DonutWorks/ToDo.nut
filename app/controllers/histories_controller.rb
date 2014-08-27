class HistoriesController < ApplicationController
  
  before_action :find_project
  respond_to :json
  
  def index
    @histories = History.all
  end

  def new
    @history = History.new
    @todos = Todo.all
    @users = User.all
    gon.project_id = @project.id
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
      send_notifications!
    end

    #url_helper -> project_history(@project, @history) is okay?
    SlackNotifier.notify("히스토리가 수정되었어용 : #{@history.title} (#{Rails.application.routes.url_helpers.project_history_url(@project, @history)})")
    MailSender.send_email_when_create(current_user.email, @history)

    redirect_to project_path(@project)

  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def show
    @history = History.find(params[:id])
    gon.project_id = params[:project_id]
  end

  def edit
    @history = History.find(params[:id])
    @todos = Todo.all
    @users = User.all
    gon.project_id = @project.id
  end

  def update
    @history = History.find(params[:id])

    @history.transaction do
      associate_history_with_histories!
      associate_history_with_todos!
      associate_history_with_assignees!
      associate_history_with_images!
      @history.update!(history_params)
      send_notifications!
    end

    #url_helper -> project_history(@project, @history) is okay?
    SlackNotifier.notify("히스토리가 수정되었어용 : #{@history.title} (#{Rails.application.routes.url_helpers.project_history_url(@project, @history)})")
    redirect_to [@project, @history]

  rescue ActiveRecord::RecordInvalid
    render 'edit'
  end

  def destroy
    @history = History.find(params[:id])
    @history.destroy

    redirect_to project_path(@project)
  end

  def list
    from_id = params[:id] || 0
    histories = @project.histories.fetch_list_from(from_id, 5)
    respond_with histories
  end

  private
  def history_params
    params.require(:history).permit(:title, :description, :evented_at, :project_id)
  end

  def find_project
    @project = current_user.assigned_projects.find(params[:project_id])
  end

  def send_notifications!
    mentioned_users = @history.description.scan(/\B@([^\s]+)\b/).flatten!.to_a
    mentioned_users.map! { |nickname| User.find_by_nickname(nickname) }
    mentioned_users.each do |user|
      @history.create_activity(action: 'mention', recipient: user, owner: current_user)
    end
  end

  # metaprogramming?
  def associate_history_with_histories!
    referenced_histories = ReferenceCheck::ForHistory.references(params[:history][:description])

    @history.referencing_histories.destroy_all
    referenced_histories.each do |history|
      @history.history_histories.build(referencing_history_id: history.id)
    end if referenced_histories != nil
  end

  def associate_history_with_todos!
    referenced_todos = ReferenceCheck::ForTodo.references(params[:history][:description])

    @history.todos.destroy_all
    referenced_todos.each do |todo|
      @history.history_todos.build(todo_id: todo.id)
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
