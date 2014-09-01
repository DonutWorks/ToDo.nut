class UsersController < ApplicationController
	skip_before_action :authenticate_user!
  def show
  	@user = User.find_by_nickname(params[:nickname])
  end

  def merge
  end

  def merge_callback

    @user = User.find_by_email(params[:user][:email])
    @user.provider = params[:user][:provider]
    @user.uid = params[:user][:uid]
    
    if @user.valid_password?(params[:user][:password])
      if @user.save
        sign_in_and_redirect @user, :event => :authentication
      else
        render merge_users_path
      end
    else
      flash[:notice] = "Password is not valid!"
      render merge_users_path       
    end
  end

  def nickname_new
  end

  def nickname_new_callback
    @user = User.new(params[:user].permit!)

    if @user.save
      sign_in_and_redirect @user, :event => :authentication
    else
      render nickname_new_users_path
    end    

  end

  def sign_up_from_twitter
  end

  def sign_up_from_twitter_callback
    @user = User.new(params[:user].permit!)

    if @user.save
      sign_in_and_redirect @user, :event => :authentication
    else
      render sign_up_from_twitter_users_path
    end 
  end
end
