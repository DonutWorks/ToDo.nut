class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  # migration for new field nickname which is required field.
  before_action :is_nickname_not_empty?

  
  
  protected
  def find_project
    project_id = params[:project_id]
    if project_id != nil
      @project = Project.find(project_id)
    end

  end

  protected
  def is_assignee?
    project_id = params[:project_id] 
    if (current_user.assigned_projects.find(project_id))==nil
      #if project doesn't exist, this will make an exception.
      #redirect_to root_path
    end
  end
  
  def is_assignee_for_project?
    project_id = params[:id]   
    if (current_user.assigned_projects.find(project_id))==nil
      #if project doesn't exist, this will make an exception.
      #redirect_to root_path
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
