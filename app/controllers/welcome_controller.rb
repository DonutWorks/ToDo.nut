class WelcomeController < ApplicationController
  def index
    @todos = Todo.all
  	@histories = History.all
  end
end
