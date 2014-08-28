class UserDecorator < BaseDecorator

  def email
    h.link_to object.email, show_user_path(object.nickname)
  end

end