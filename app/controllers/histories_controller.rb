class HistoriesController < ApplicationController
	def new
	end

	def create
		@history = History.new(history_params)

		@history.save
		redirect_to @history
	end

	private
	def history_params
		params.require(:history).permit(:title, :description)
		
	end
end
