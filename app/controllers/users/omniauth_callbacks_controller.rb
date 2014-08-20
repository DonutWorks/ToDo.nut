class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_oauth2(request.env["omniauth.auth"])

    if @user.persisted? and @user.uid != nil
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect @user, :event => :authentication
    elsif @user.persisted? and @user.uid == nil
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to users_merge_path(@user.id, 'facebook_data')
    end
  end

  def google_oauth2
    @user = User.find_for_oauth2(request.env["omniauth.auth"])

    if @user.persisted? and @user.uid != nil
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      sign_in_and_redirect @user, :event => :authentication
    elsif @user.persisted? and @user.uid == nil
      session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to users_merge_path(@user.id, 'google_data')
    end
  end

    def twitter
    @user = User.find_for_twitter_oauth(request.env["omniauth.auth"])
    time = [@user.created_at, @user.updated_at]

    if @user.persisted? and time[0] != time[1]
      sign_in_and_redirect @user, :event => :authentication
      set_flash_message(:notice, :success, :kind => "Twitter") if is_navigational_format?
    else
      redirect_to sign_up_from_twitter_path(@user.id)
    end
  end
end
