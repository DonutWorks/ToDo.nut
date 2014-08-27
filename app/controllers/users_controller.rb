class UsersController < ApplicationController
	skip_before_action :authenticate_user!
  def show
  	@user = User.find_by_nickname(params[:nickname])
  end

  def merge
  end

  def merge_callback
    @user = User.find_by_email(params[:email])
    
    if @user.valid_password?(params[:password])
      @user.merge(@user.id, params[:provider], params[:uid])

      sign_in_and_redirect @user, :event => :authentication
    else
      redirect_to root_path
    end        
  end

  def nickname_new
  end

  def nickname_new_callback
    @user = User.create!(
      provider: params[:provider],
      uid: params[:uid],
      email: params[:email],
      nickname: params[:nickname]
    )

    sign_in_and_redirect @user, :event => :authentication
  end

  def sign_up_from_twitter
  end

  def sign_up_from_twitter_callback
    if User.find_by_email(params[:user][:email])
      @user = User.new
      render sign_up_from_twitter_users_path
    else
      @user = User.new(
          provider: params[:user][:provider],
          uid: params[:user][:uid],
          nickname: params[:user][:nickname]
        )

      @user.email = params[:user][:email]

      @user.save!
      sign_in_and_redirect @user, :event => :authentication
    end   
  end
end
