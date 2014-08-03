class HistoriesController < ApplicationController
	def index
		@histories = History.all
	end

	def new
	end

	def create
		@history = History.new(history_params)

		@history.save
		redirect_to root_path
	end

	def show
		@history = History.find(params[:id])
	end

	private
	def history_params
		params.require(:history).permit(:title, :description)
		
	end
end
