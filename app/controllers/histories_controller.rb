class HistoriesController < ApplicationController
  def index
    @histories = History.all
  end

  def new
    @history = History.new
    @todos = Todo.all
    @users = User.all
  end

  def create
    client = SlackNotify::Client.new("donutworks", "G0QAYXA6uqygRTXjXCZ5Th2g")

    @history = History.new(history_params)
    @history.user_id = current_user.id

    @history.transaction do
      associate_history_with_todos!
      associate_history_with_assignees!
      associate_history_with_images!
      @history.save!
    end
    client.notify("히스토리가 추가되었어용 : #{@history.title} (#{Rails.application.routes.url_helpers.history_url(@history)})")
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
  end

  def update
    client = SlackNotify::Client.new("donutworks", "G0QAYXA6uqygRTXjXCZ5Th2g")

    @history = History.find(params[:id])

    @history.transaction do
      associate_history_with_todos!
      associate_history_with_assignees!
      associate_history_with_images!
      @history.update!(history_params)
    end
    client.notify("히스토리가 수정되었어용 : #{@history.title} (#{Rails.application.routes.url_helpers.history_url(@history)})")
    redirect_to @history
  rescue ActiveRecord::RecordInvalid
    render 'edit'
  end

  def destroy
    @history = History.find(params[:id])
    @history.destroy

    redirect_to root_path
  end

  private
  def history_params
    params.require(:history).permit(:title, :description, :evented_at)
  end

  # metaprogramming?
  def associate_history_with_todos!
    @history.todos.destroy_all
    params[:history][:todo_ids].select!(&:present?).each do |id|
      @history.history_todos.build(todo_id: id)
    end
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
    end
  end
end
