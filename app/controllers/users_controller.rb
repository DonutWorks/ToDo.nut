class UsersController < ApplicationController
	skip_before_action :authenticate_user!
  def show
  	@user = User.find_by_nickname(params[:nickname])
  end

  def merge
    

    @user = User.find(params[:id])
    @provider = params[:provider]

    if params[:callback] == 'callback'
      provider_session = session["devise." + @provider]

      @user.merge(params[:id], provider_session["provider"], provider_session["uid"])
      redirect_to root_path 
    end

  end
end
