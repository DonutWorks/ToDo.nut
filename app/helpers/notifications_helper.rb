module NotificationsHelper
  def nav_link_to (text, link)
    active = "active" if current_page?(link)
    content_tag :li, class: active do 
      link_to text, link
    end
  end
end
