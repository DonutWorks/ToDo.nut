class TodosController < ApplicationController
  def new
    @todo = Todo.new
  end

  def create
    client = SlackNotify::Client.new("donutworks", "G0QAYXA6uqygRTXjXCZ5Th2g")

    @todo = Todo.new(todo_params)
    if @todo.save
      client.notify("투두가 추가되었어용 : #{@todo.title} (#{Rails.application.routes.url_helpers.todo_url(@todo)})")
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
    client = SlackNotify::Client.new("donutworks", "G0QAYXA6uqygRTXjXCZ5Th2g")

    @todo = Todo.find(params[:id])

    if @todo.update(todo_params)
      client.notify("투두가 수정되었어용 : #{@todo.title} (#{Rails.application.routes.url_helpers.todo_url(@todo)})")

      redirect_to @todo
    else
      render 'edit'
    end
  end


private 
  def todo_params
    params.require(:todo).permit(:title)
  end
end
