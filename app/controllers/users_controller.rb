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

  def sign_up_from_twitter
  end

  def sign_up_from_twitter_callback
    auth = session["devise.twitter_data"]

    @user = User.new(provider:auth["provider"],
        uid:auth["uid"],
        nickname: auth["extra"]["raw_info"]["screen_name"],
        password: Devise.friendly_token[0,20])

    @user.email = params[:user]["email"]

    @user.save!
    sign_in_and_redirect @user, :event => :authentication
  end
end
