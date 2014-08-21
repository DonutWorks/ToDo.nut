class UserDecorator < Draper::Decorator
	# For user_path
  include Rails.application.routes.url_helpers

  def email
    h.link_to object.email, show_user_path(object.nickname)
  end

end