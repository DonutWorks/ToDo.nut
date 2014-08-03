class HistoriesController < ApplicationController
	def index
		@histories = History.all
	end

	def new
		@history = History.new
		@todos = Todo.all
	end

	def create
		@history = History.new(history_params)

		@history.save

		params[:history][:todo_ids].each do |id|
			history_todo = HistoryTodo.new
			history_todo.history_id = @history.id
			history_todo.todo_id = id
			history_todo.save
		end

		redirect_to root_path
	end

	def show
		@history = History.find(params[:id])
	end

	def edit
		@history = History.find(params[:id])
		@todos = Todo.all
	end

	def update
		@history = History.find(params[:id])

		if @history.update(history_params)
			@history.todos.destroy_all
			params[:history][:todo_ids].each do |id|
				history_todo = HistoryTodo.new
				history_todo.history_id = @history.id
				history_todo.todo_id = id
				history_todo.save
			end
			redirect_to @history
		else
			render 'edit'
		end
	end

	private
	def history_params
		params.require(:history).permit(:title, :description, :evented_at)
		
	end
end
