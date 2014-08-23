class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_oauth2(request.env["omniauth.auth"])

    if @user.nil?
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to users_merge_path('facebook')
    else
      sign_in_and_redirect @user, :event => :authentication
    end
  end

  def google_oauth2
    @user = User.find_for_oauth2(request.env["omniauth.auth"])

    if @user.nil?
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to users_merge_path('facebook')
    else
      sign_in_and_redirect @user, :event => :authentication
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
