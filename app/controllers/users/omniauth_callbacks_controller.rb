class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def self.provides_callback_for(provider)
    class_eval %Q{
      def #{provider}
        @provider = "#{provider}"
        @uid = request.env["omniauth.auth"].uid
        result = User.find_for_oauth(@provider, request.env["omniauth.auth"])

        case @provider
        when "twitter"
          @nickname = request.env["omniauth.auth"]["extra"]["raw_info"].screen_name

          case result[:status] 
          when :success
            @user = result[:data]
            sign_in_and_redirect @user, :event => :authentication 

          when :first_login
            @user = User.new
            render sign_up_from_twitter_users_path
          end

        else
          @email = request.env["omniauth.auth"]["info"].email

          case result[:status]
          when :success
            @user = result[:data]
            sign_in_and_redirect @user, :event => :authentication

          when :first_login
            @user = User.new
            render nickname_new_users_path

          when :duplicated
            @user = User.find_by_email(@email)
            render merge_users_path
           end

        end
      end
    }
  end

  [:twitter, :facebook, :google_oauth2].each do |provider|
    provides_callback_for provider
  end
end
