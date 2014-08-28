class ProjectsController < ApplicationController

  respond_to :json
  before_action :find_project, except:[:index, :new, :create]
  

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


    if @project.save
      #associate_project_with_todos!
      associate_project_with_assignees!


      SlackNotifier.notify("프로젝트 추가되었어용 : #{@project.title} (#{Rails.application.routes.url_helpers.project_url(@project.project_owner, @project.title)})")
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
    

    if @project.update(project_params)
      #associate_project_with_todos!
      associate_project_with_assignees!

      SlackNotifier.notify("프로젝트가 수정되었어용 : #{@project.title} (#{Rails.application.routes.url_helpers.project_url(@project.project_owner, @project.title)})")
      redirect_to detail_project_path(@project.project_owner, @project.title)
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
    
    @project = current_user.assigned_projects.where(title: params[:title]).first
    
      #if project doesn't exist, this will make an exception.
      #Should make exception handler
  end

  
end
