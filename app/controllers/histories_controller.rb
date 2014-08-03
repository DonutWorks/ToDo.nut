class HistoriesController < ApplicationController
	def index
		@histories = History.all
	end

	def new
		@history = History.new
		@todos = Todo.all
	end

	def create
		client = SlackNotify::Client.new("donutworks", "G0QAYXA6uqygRTXjXCZ5Th2g")

		@history = History.new(history_params)

		@history.save
    client.notify("히스토리가 추가되었어용 : #{@history.title} (#{Rails.application.routes.url_helpers.history_url(@history)})")

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
		client = SlackNotify::Client.new("donutworks", "G0QAYXA6uqygRTXjXCZ5Th2g")

		@history = History.find(params[:id])

		if @history.update(history_params)
			client.notify("히스토리가 수정되었어용 : #{@history.title} (#{Rails.application.routes.url_helpers.history_url(@history)})")

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
		params.require(:history).permit(:title, :description)
		
	end
end
