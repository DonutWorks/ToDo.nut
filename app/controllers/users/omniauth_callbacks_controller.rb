class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_oauth2(request.env["omniauth.auth"])

    if @user.persisted? and @user.uid != nil
      sign_in_and_redirect @user, :event => :authentication
    elsif @user.persisted? and @user.uid == nil
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to users_merge_path(@user.id, 'facebook_data')
    end
  end

  def google_oauth2
    @user = User.find_for_oauth2(request.env["omniauth.auth"])

    if @user.persisted? and @user.uid != nil
      sign_in_and_redirect @user, :event => :authentication
    elsif @user.persisted? and @user.uid == nil
      session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to users_merge_path(@user.id, 'google_data')
    end
  end

  def twitter
    @user = User.find_for_twitter_oauth(request.env["omniauth.auth"])

    if @user.nil?
      @user = User.new
      session["devise.twitter_data"] = request.env["omniauth.auth"]
      render sign_up_from_twitter_path
    else
      sign_in_and_redirect @user, :event => :authentication      
    end
  end
end
