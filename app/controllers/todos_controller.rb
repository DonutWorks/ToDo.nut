class TodosController < ApplicationController
  before_action :find_project
  before_action :is_assignee?

  def new
    @todo = Todo.new
  
  end

  def create
    @todo = Todo.new(todo_params)
    @todo.user_id = current_user.id
  
    @todo.project_id = @project.id
    
    if @todo.save
      #url_helper -> project_todo_url is okay?
      SlackNotifier.notify("투두가 추가되었어용 : #{@todo.title} (#{Rails.application.routes.url_helpers.project_todo_url(@project, @todo)})")
      redirect_to main_projects_path(@project)
    else 
      render 'new'
    end 
  end

  def show
    @todo = Todo.find(params[:id])
  
  end

  def edit
    
    @todo = Todo.find(params[:id])
  end

  def update 
    @todo = Todo.find(params[:id])
    
    if @todo.update(todo_params)
      SlackNotifier.notify("투두가 추가되었어용 : #{@todo.title} (#{Rails.application.routes.url_helpers.project_todo_url(@project, @todo)})")
      redirect_to main_projects_path(@project)
    else
      render 'edit'
    end
  end

  def list
    from_id = params[:id] || 0
    todos = Todo.where(project_id: params[:project_id]).fetch_list_from(from_id, 5)
    render json: todos
  end

private 
  def todo_params
    params.require(:todo).permit(:title, :color, :duedate)
  end
end
