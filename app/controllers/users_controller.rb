class UsersController < ApplicationController
	skip_before_action :authenticate_user!
  def show
  	@user = User.find(params[:id])
  end

  def merge
    @my_logger ||= Logger.new("#{Rails.root}/log/my.log")

    @user = User.find(params[:id])

    if params[:callback] == 'callback'
      provider_session = session["devise." + params[:provider]]
      
      @user.merge(params[:id], provider_session["provider"], provider_session["uid"])
      redirect_to root_path 
    end

  end
end
