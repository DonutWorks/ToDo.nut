class ProjectsController < ApplicationController
  def new
    @project = Project.new
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

      SlackNotifier.notify("프로젝트 추가되었어용 : #{@project.title} (#{Rails.application.routes.url_helpers.project_url(@project)})")
    end
    redirect_to projects_path
  end
  
  def show
    @project = Project.find(params[:id])
    
  end

  def main
    @todo = Todo.new    
    @todos = Todo.where(project_id: params[:project_id])
    @histories = History.where(project_id: params[:project_id])
    @project = Project.find(params[:project_id])
    gon.deco = decorate
    #@data = gon.deco
    # render plain: decorate

    # output = File.open( "../assets/javascripts/test_data.json", w+)
    # output << decorate
    # output.close
  end

  def edit
    @project = Project.find(params[:id])
    #@todos = Todo.all
    @users = User.all
  end

  def update
    @project = Project.find(params[:id])

    if @project.update(project_params)
      #associate_project_with_todos!
      associate_project_with_assignees!

      SlackNotifier.notify("프로젝트가 수정되었어용 : #{@project.title} (#{Rails.application.routes.url_helpers.project_url(@project)})")
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

private 
  def decorate
    data=[];

    @todos.each do |t|
      articles = [];
      

      total = 0
    
      t.histories.each do |h|
        articles.push([(h.evented_at.to_date-Time.now.to_date).to_i,5])
        total += 5
      end
      
      duetime = ""
      if t.duedate != nil
        duetime = t.duedate.strftime('%m/%d')
      end
      
      data.push({
        "id" => t.id,
        "project_id" => t.project_id,
        "articles" => articles,
        "total" => total,
        "name" => t.title,
        "color" => t.color,
        "duedate" => duetime
      })

    end

    

    return data.to_json

  end
  
end
