class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # def facebook
  #   # You need to implement the method below in your model (e.g. app/models/user.rb)
  #   @user = User.from_omniauth(request.env["omniauth.auth"])

  #   if @user.persisted? and @user.uid != nil
  #     sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
  #     set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
  #   elsif @user.persisted? and @user.uid == nil
      

  #     session["devise.facebook_data"] = request.env["omniauth.auth"]
  #     redirect_to users_merge_path(@user.id, 'facebook_data')
  #   else
  #     session["devise.facebook_data"] = request.env["omniauth.auth"]
  #     redirect_to new_user_registration_url
  #   end
  # end

  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_google_oauth2(request.env["omniauth.auth"], current_user)

    # OAuth 성공
    if @user.persisted? and @user.uid != nil
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect @user, :event => :authentication
    # 중복 이메일이 있을 경우
    elsif @user.persisted? and @user.uid == nil
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to users_merge_path(@user.id, 'facebook_data')
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def google_oauth2
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_google_oauth2(request.env["omniauth.auth"], current_user)

    # OAuth 성공
    if @user.persisted? and @user.uid != nil
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      sign_in_and_redirect @user, :event => :authentication
    # 중복 이메일이 있을 경우
    elsif @user.persisted? and @user.uid == nil
      session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to users_merge_path(@user.id, 'google_data')
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
  
  def twitter
    @user = User.find_for_twitter_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted? and @user.uid != nil
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Twitter") if is_navigational_format?
    elsif @user.persisted? and @user.uid == nil
      session["devise.twitter_data"] = request.env["omniauth.auth"]
      redirect_to users_merge_path(@user.id, 'twitter_data')
    else
      session["devise.twitter_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
  
end