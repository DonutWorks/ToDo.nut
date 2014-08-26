class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_oauth2(request.env["omniauth.auth"])

    session["omniauth"] = {
      provider: request.env["omniauth.auth"].provider,
      uid: request.env["omniauth.auth"].uid,
      email: request.env["omniauth.auth"]["info"].email
    }
    
    if @user.nil?
      render nickname_new_users_path
    elsif @user.duplicated?
      redirect_to merge_users_path   
    else
      sign_in_and_redirect @user, :event => :authentication
    end
  end

  def google_oauth2
    @user = User.find_for_oauth2(request.env["omniauth.auth"])

    session["omniauth"] = {
      provider: request.env["omniauth.auth"].provider,
      uid: request.env["omniauth.auth"].uid,
      email: request.env["omniauth.auth"]["info"].email
    }

    if @user.nil?
      render nickname_new_users_path
    elsif @user.duplicated?
      redirect_to merge_users_path   
    else
      sign_in_and_redirect @user, :event => :authentication
    end
  end

  def twitter
    @user = User.find_for_twitter_oauth(request.env["omniauth.auth"])

    if @user.nil?
      @user = User.new

      session["omniauth"] = {
        provider: request.env["omniauth.auth"].provider,
        uid: request.env["omniauth.auth"].uid,
        nickname: request.env["omniauth.auth"]["extra"]["raw_info"].screen_name
      }

      render sign_up_from_twitter_users_path
    else
      sign_in_and_redirect @user, :event => :authentication      
    end
  end
end
