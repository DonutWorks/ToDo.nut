class ProjectsController < ApplicationController

  before_action :find_project, except:[:index, :new, :create]
  respond_to :json
  
  def new
    @project = Project.new
    @project.user = current_user
    @users = User.all
  end

  def index
    @projects = current_user.assigned_projects
  end

  def create
    @project = Project.new(project_params)
    @project.user_id = current_user.id
    @project.assign_users_with_ids!(params[:project][:assignee_ids])

    if @project.save
      SlackNotifier.notify("프로젝트 추가되었어용 : #{@project.title} (#{project_url(@project.project_owner, @project.title)})")
      MailSender.send_email_when_create(current_user.email, @project)
    end
    redirect_to projects_path
  end
  
  def detail

  end

  def show
    @todo = Todo.new    
    @todos = @project.todos
    @histories = @project.histories
  end

  def edit
    @users = User.all
  end

  def update
    @project.assign_users_with_ids!(params[:project][:assignee_ids])

    if @project.update(project_params)
      SlackNotifier.notify("프로젝트가 수정되었어용 : #{@project.title} (#{project_url(@project.project_owner, @project.title)})")
      redirect_to detail_project_path(@project.user, @project)
    else
      render 'edit'
    end
  end
  
  def destroy
    @project.destroy
    redirect_to projects_path
  end

  def members
    members = @project.fetch_members_by_nickname(params[:nickname], 5)
    respond_with members
  end

private 
  def project_params
    params.require(:project).permit(:title, :description)
  end

  def find_project
    #if project doesn't exist, this will make an exception.
    #Should make exception handler
    @project = current_user.assigned_projects.where(title: params[:title]).first
  end
    
end
