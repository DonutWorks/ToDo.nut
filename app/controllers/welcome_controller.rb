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
		data = {
			"articles" => [],
			"total" => 0,
			"name" => "history name"
		}

		total = 0
		
		@todos.each do |t|
			data["articles"].push([t.created_at.day,5])
			total += 5
		end

		data["total"] = total

		return [data].to_json

	end
end
