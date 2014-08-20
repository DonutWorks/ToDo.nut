class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :is_nickname_not_empty?

  def update
    if current_user.provider == nil
      super
    else
      account_update_params = devise_parameter_sanitizer.sanitize(:account_update)

      # required for settings form to submit when password is left blank
      if account_update_params[:password].blank?
        account_update_params.delete("password")
        account_update_params.delete("password_confirmation")
        account_update_params.delete("current_password")
      end

      @user = User.find(current_user.id)
      if @user.update_attributes(account_update_params)
        set_flash_message :notice, :updated
        # Sign in the user bypassing validation in case their password changed
        sign_in @user, :bypass => true
        redirect_to after_update_path_for(@user)
      else
        render "edit"
      end
    end
  end
end
