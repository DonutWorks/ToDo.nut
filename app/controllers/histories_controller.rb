class HistoriesController < ApplicationController
	def index
		@histories = History.all
	end

	def new
		@history = History.new
	end

	def create
		@history = History.new(history_params)

		@history.save
		redirect_to root_path
	end

	def show
		@history = History.find(params[:id])
	end

	def edit
		@history = History.find(params[:id])
	end

	def update
		@history = History.find(params[:id])

		if @history.update(history_params)
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
