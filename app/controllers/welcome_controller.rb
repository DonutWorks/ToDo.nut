class WelcomeController < ApplicationController
  def index
  	@histories = History.all
  end
end
