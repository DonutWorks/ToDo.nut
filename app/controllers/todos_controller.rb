class TodosController < ApplicationController

  before_action :find_project
  respond_to :json


  def new
    @todo = Todo.new
  
  end

  def create
    @todo = Todo.new(todo_params)
    @todo.user_id = current_user.id
    @todo.project_id = @project.id

    
    if @todo.save
      #url_helper -> project_todo_url is okay?

      SlackNotifier.notify("투두가 추가되었어용 : #{@todo.title} (#{Rails.application.routes.url_helpers.project_todo_url(@project.project_owner, @project.title, @todo)})")
      MailSender.send_email_when_create(@current_user.email, @todo)
      redirect_to project_path(@project.project_owner, @project.title)
    else 
      render 'new'
    end 
  end

  def show

    @todo = TodoDecorator.find_by_ptodo_id(params[:ptodo_id])

  
  end

  def edit
    
    @todo = @project.todos.find_by_ptodo_id(params[:ptodo_id])
  end

  def update 
    @todo = @project.todos.find_by_ptodo_id(params[:ptodo_id])
    
    if @todo.update(todo_params)
      SlackNotifier.notify("투두가 추가되었어용 : #{@todo.title} (#{Rails.application.routes.url_helpers.project_todo_url(@project.project_owner, @project.title, @todo)})")
      redirect_to project_path(@project.project_owner, @project.title)
    else
      render 'edit'
    end
  end

  def list
    from_id = params[:ptodo_id] || 0
    todos = @project.todos.fetch_list_from(from_id, 5)
    respond_with todos
  end

private 
  def todo_params
    params.require(:todo).permit(:title, :color, :duedate)
  end

  def find_project
    
    @project = current_user.assigned_projects.find_by_title(params[:project_title])
  end
end
