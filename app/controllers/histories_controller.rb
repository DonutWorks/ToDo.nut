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
    @history = History.new(history_params)
    @history.project = @project
    @history.user = current_user
    @history.attach_images!(params[:history][:images])
    @history.assign_users_with_ids!(params[:history][:assignee_ids])

    if @history.save
      SlackNotifier.notify("히스토리가 생성되었어용 : #{@history.title} (#{project_history_url(@project.project_owner, @project.title, @history)})")
      redirect_to project_history_path(@project.user, @project, @history)
    else
      render 'new'
    end
  end

  def show
    @history = @project.find_history(params[:phistory_id])

    gon.project_id = @project.id
    gon.project_creator = @project.project_owner
    gon.project_title = @project.title
  end

  def edit
    @history = @project.find_history(params[:phistory_id])
    @todos = @project.todos
    @users = @project.assignees
    gon.project_creator = @project.project_owner
    gon.project_title = @project.title
  end

  def update
    @history = @project.find_history(params[:phistory_id])
    @history.attach_images!(params[:history][:images])
    @history.assign_users_with_ids!(params[:history][:assignee_ids])

    if @history.save
      SlackNotifier.notify("히스토리가 수정되었어용 : #{@history.title} (#{project_history_url(@project.project_owner, @project.title, @history)})")
      redirect_to project_history_path(@project.user, @project, @history)
    else
      render 'edit'
    end
  end

  def destroy
    @history = @project.find_history(params[:phistory_id])
    @history.destroy

    redirect_to project_path(@project.user, @project)
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
    @project = current_user.find_project(params[:project_title])
  end
end
