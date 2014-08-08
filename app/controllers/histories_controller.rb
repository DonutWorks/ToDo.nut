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
    #referenced_users = params[:history][:description].scan(/\B@(\w+)\b/).flatten!
    referenced_histories = params[:history][:description].scan(/\B#(\d+)\b/).flatten!

    client = SlackNotify::Client.new("donutworks", "G0QAYXA6uqygRTXjXCZ5Th2g")

    @history = History.new(history_params)
    @history.user_id = current_user.id

    @history.transaction do
      associate_history_with_todos!
      associate_history_with_assignees!
      associate_history_with_images!
      @history.save!
    end
    #client.notify("히스토리가 추가되었어용 : #{@history.title} (#{Rails.application.routes.url_helpers.history_url(@history)})")
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

  def list
    histories = []
    if params[:id] == nil
      histories = History.first(5)
    else
      histories = History.where("id >= ?", params[:id]).take(5)
    end
    render json: histories
  end

  def list_members
    render json: User.all
  end

  private
  def history_params
    params.require(:history).permit(:title, :description, :evented_at)
  end

  # metaprogramming?
  def associate_history_with_todos!
    referenced_todos = params[:history][:description].scan(/\B\!(\d+)\b/).flatten!

    @history.todos.destroy_all
    referenced_todos.each do |id|
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
    end if params[:history][:images] != nil
  end
end
