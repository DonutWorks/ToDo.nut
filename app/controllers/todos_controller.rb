class TodosController < ApplicationController
  def new
    @todo = Todo.new
  end

  def create
    @todo = Todo.new(todo_params)
    @todo.user_id = current_user.id
    
    if @todo.save
      SlackNotifier.instance.notify("투두가 추가되었어용 : #{@todo.title} (#{Rails.application.routes.url_helpers.todo_url(@todo)})")
      redirect_to root_path
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
      SlackNotifier.instance.notify("투두가 수정되었어용 : #{@todo.title} (#{Rails.application.routes.url_helpers.todo_url(@todo)})")
      redirect_to @todo
    else
      render 'edit'
    end
  end

  def list
    from_id = params[:id] || 0
    todos = Todo.fetch_list_from(from_id, 5)
    render json: todos
  end

private 
  def todo_params
    params.require(:todo).permit(:title, :color, :duedate)
  end
end
