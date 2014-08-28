class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def authenticate(provider)
    @user = User.new(
          provider: provider,
          uid: request.env["omniauth.auth"].uid)

    result = User.find_for_oauth(provider, request.env["omniauth.auth"])

    case provider
    when :twitter
      @user.nickname = request.env["omniauth.auth"]["extra"]["raw_info"].screen_name

      case result[:status]
      when :success
        @user = result[:data]
        sign_in_and_redirect @user, :event => :authentication

      when :first_login
        render sign_up_from_twitter_users_path
      end

    else
      @user.email = request.env["omniauth.auth"]["info"].email

      case result[:status]
      when :success
        @user = result[:data]
        sign_in_and_redirect @user, :event => :authentication

      when :first_login
        render nickname_new_users_path

      when :duplicated
        @user = User.find_by_email(@user.email)
        render merge_users_path

      when :duplicated_by_oauth
        flash[:notice] = result[:data] + " 서비스로 이미 회원가입 되어있습니다. 해당 서비스로 로그인해주세요"
        redirect_to new_user_session_path
      end
    end
  end

  def twitter
    authenticate(:twitter)
  end

  def facebook
    authenticate(:facebook)
  end

  def google_oauth2
    authenticate(:google_oauth2)
  end
end
