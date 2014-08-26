class UsersController < ApplicationController
	skip_before_action :authenticate_user!
  def show
  	@user = User.find_by_nickname(params[:nickname])
  end

  def merge
    @user = User.where(email: session["omniauth"]["email"]).first
  end

  def merge_callback
    auth = session["omniauth"]
    @user = User.where(email: auth["email"]).first
    
    if @user.valid_password?(params[:password])
      @user.merge(@user.id, auth["provider"], auth["uid"])
      sign_in_and_redirect @user, :event => :authentication
    else
      redirect_to root_path
    end        
  end

  def nickname_new
  end

  def nickname_new_callback
    auth = session["omniauth"]

    @user = User.create!(provider:auth["provider"],
      uid: auth["uid"],
      email: auth["email"],
      nickname: params[:nickname])
    sign_in_and_redirect @user, :event => :authentication
  end

  def sign_up_from_twitter
  end

  def sign_up_from_twitter_callback
    if User.where(email: params[:user]["email"]).first
      @user = User.new
      render sign_up_from_twitter_users_path
    else
      auth = session["omniauth"]

      @user = User.new(provider:auth["provider"],
          uid:auth["uid"],
          nickname: auth["nickname"])

      @user.email = params[:user]["email"]

      @user.save!
      sign_in_and_redirect @user, :event => :authentication
    end   
  end
end
