class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  # migration for new field nickname which is required field.
  before_action :is_nickname_not_empty?

  #authentication_project (skip_action)
  before_action :is_assignee?
  
  protected
  def is_assignee?
    project_id = params[:project_id] 
    if project_id != nil
      if (current_user.assigned_projects.find_by_id(project_id))==nil
        redirect_to root_path
      end
    end
  end

  #routes problem....
  def is_project_assignee?
    project_id = params[:id] 
    if project_id != nil
      if (current_user.assigned_projects.find_by_id(project_id))==nil
        redirect_to root_path
      end
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :nickname
    devise_parameter_sanitizer.for(:account_update) << :nickname
  end

  def is_nickname_not_empty?
    redirect_to edit_user_registration_path if user_signed_in? and current_user.nickname.empty?
  end
  
end
