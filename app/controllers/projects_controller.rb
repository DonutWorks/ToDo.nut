class ProjectsController < ApplicationController

  respond_to :json
  before_action :find_project, except:[:index, :new, :create]
  

  def new
    @project = Project.new
    @users = User.all
  end

  def index
    @projects = current_user.assigned_projects
  end

  def create
    @project = Project.new(project_params)
    @project.user = current_user
    @users = User.all
 
    if @project.save
      #associate_project_with_todos!
      associate_project_with_assignees!

      SlackNotifier.notify("프로젝트 추가되었어용 : #{@project.title} (#{Rails.application.routes.url_helpers.project_url(@project)})")
      MailSender.send_email_when_create(current_user.email, @project)
      redirect_to projects_path
    else
      flash[:error] = @project.errors.full_messages.join('\n')
      render 'new'
    end
  end
  
  def detail
    @project = Project.find(params[:id])
  end

  def show
    @todo = Todo.new    
    @todos = Todo.where(project_id: params[:id])
    @histories = History.where(project_id: params[:id])
  end

  def edit
    @project = Project.find(params[:id])
    #@todos = Todo.all
    @users = User.all
  end

  def update
    @project = Project.find(params[:id])
    @users = User.all

    if @project.update(project_params)
      #associate_project_with_todos!
      associate_project_with_assignees!

      SlackNotifier.notify("프로젝트가 수정되었어용 : #{@project.title} (#{Rails.application.routes.url_helpers.project_url(@project)})")
      redirect_to @project
    else
      flash[:error] = @project.errors.full_messages.join('\n')
      render 'edit'
    end
  end
  
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    redirect_to projects_path
  end

  def members
    @project = Project.find(params[:id])
    
    members = @project.fetch_members_by_nickname(params[:nickname], 5)
    respond_with members
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

  def find_project
    
    @project = current_user.assigned_projects.find(params[:id] )
      #if project doesn't exist, this will make an exception.
      #Should make exception handler
  end

  
end
