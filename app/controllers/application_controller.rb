class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  # migration for new field nickname which is required field.
  before_action :is_nickname_not_empty?

  
  
  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :nickname
    devise_parameter_sanitizer.for(:account_update) << :nickname
  end

  def is_nickname_not_empty?
    # default value of nickname is nil (#39)
    if user_signed_in? and current_user.nickname.blank?
      redirect_to edit_user_registration_path
    end
  end
  
end
