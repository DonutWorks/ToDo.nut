class TodosController < ApplicationController

  before_action :find_project
  respond_to :json

  def new
    @todo = Todo.new
  end

  def create
    @todo = Todo.new(todo_params)
    @todo.user = current_user
    @todo.project = @project
    
    if @todo.save
      SlackNotifier.notify("투두가 추가되었어용 : #{@todo.title} (#{project_todo_url(@project.user, @project, @todo)})")
      MailSender.send_email_when_create(@current_user.email, @todo)
      redirect_to project_path(@project.user, @project)
    else 
      render 'new'
    end 
  end

  def show
    @todo = @project.find_todo(params[:ptodo_id])
  end

  def edit 
    @todo = @project.find_todo(params[:ptodo_id])
  end

  def update 
    @todo = @project.find_todo(params[:ptodo_id])
    
    if @todo.update(todo_params)
      SlackNotifier.notify("투두가 추가되었어용 : #{@todo.title} (#{project_todo_url(@project.user, @project, @todo)})")
      redirect_to project_path(@project.user, @project)
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
    @project = current_user.find_project(params[:project_title])
  end
end
