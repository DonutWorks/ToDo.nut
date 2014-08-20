class NotificationsController < ApplicationController
  def show
    notis = current_user.notifications
    @notifications = notis.group_by { |noti| noti.subject.project }
    render
  end
end
