class WelcomeController < ApplicationController
	
	def index
		@todos = Todo.all
		@histories = History.all

		@data = decorate
		# render plain: decorate

		# output = File.open( "../assets/javascripts/test_data.json", w+)
		# output << decorate
		# output.close


	end

	private	
	def decorate
		data=[];

		@todos.each do |t|
			articles = [];
			

			total = 0
		
			t.histories.each do |h|
				articles.push([(h.evented_at.to_date-Time.now.to_date).to_i,5])
				total += 5
			end
			
			data.push({
				"articles" => articles,
				"total" => total,
				"name" => t.title
			})

		end

		

		return data.to_json

	end
end
