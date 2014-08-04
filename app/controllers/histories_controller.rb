class HistoriesController < ApplicationController
	def index
		@histories = History.all
	end

	def new
		@history = History.new
		@todos = Todo.all
		@users = User.all
	end

	def create
		#client = SlackNotify::Client.new("donutworks", "G0QAYXA6uqygRTXjXCZ5Th2g")

		@history = History.new(history_params)
		@history.user_id = current_user.id

		if @history.save
  	  associate_history_with_todos!
	    associate_history_with_assignees!

    	#client.notify("히스토리가 추가되었어용 : #{@history.title} (#{Rails.application.routes.url_helpers.history_url(@history)})")
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
		#client = SlackNotify::Client.new("donutworks", "G0QAYXA6uqygRTXjXCZ5Th2g")

		@history = History.find(params[:id])

		if @history.update(history_params)
	    associate_history_with_todos!
	    associate_history_with_assignees!

			#client.notify("히스토리가 수정되었어용 : #{@history.title} (#{Rails.application.routes.url_helpers.history_url(@history)})")
			redirect_to @history
		else
			render 'edit'
		end
	end

	def destroy
		@history = History.find(params[:id])
		@history.destroy

		redirect_to root_path
	end

	private
	def history_params
		params.require(:history).permit(:title, :description, :evented_at)
	end

	# metaprogramming?
	def associate_history_with_todos!
		@history.todos.destroy_all
		params[:history][:todo_ids].select!(&:present?).each do |id|
			history_todo = HistoryTodo.new
			history_todo.history_id = @history.id
			history_todo.todo_id = id
			history_todo.save
		end
	end

	def associate_history_with_assignees!
		@history.assignees.destroy_all
		params[:history][:assignee_ids].select!(&:present?).each do |id|
			history_user = HistoryUser.new
			history_user.assigned_history_id = @history.id
			history_user.assignee_id = id
			history_user.save
		end
	end
end