class ProjectsController < ApplicationController
  def new
    @project = Project.new
    @users = User.all
  end

  def index
    @projects = Project.all
  end

  def create
    client = SlackNotify::Client.new("donutworks", "G0QAYXA6uqygRTXjXCZ5Th2g")

    @project = Project.new(project_params)
    @project.user_id = current_user.id


    if @project.save
      #associate_project_with_todos!
      associate_project_with_assignees!

      client.notify("프로젝트 추가되었어용 : #{@project.title} (#{Rails.application.routes.url_helpers.project_url(@project)})")
    end
    redirect_to projects_path
  end
  
  def show
    @project = Project.find(params[:id])
    
  end

  def edit
    @project = Project.find(params[:id])
    #@todos = Todo.all
    @users = User.all
  end

  def update
    client = SlackNotify::Client.new("donutworks", "G0QAYXA6uqygRTXjXCZ5Th2g")

    @project = Project.find(params[:id])

    if @project.update(project_params)
      #associate_project_with_todos!
      associate_project_with_assignees!

      client.notify("프로젝트가 수정되었어용 : #{@project.title} (#{Rails.application.routes.url_helpers.project_url(@project)})")
      redirect_to @project
    else
      render 'edit'
    end
  end
  
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    redirect_to projects_path
  end

  def associate_project_with_assignees!
    @project.assignees.destroy_all
    params[:project][:assignee_ids].select!(&:present?).each do |id|
      project_user = ProjectUser.new
      project_user.assigned_project_id = @project.id
      project_user.assignee_id = id
      project_user.save
    end
  end



private 
  def project_params
    params.require(:project).permit(:title, :description)
  end

end
