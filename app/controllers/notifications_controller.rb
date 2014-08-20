class NotificationsController < ApplicationController
  def show
    unread_notis = Notification.unread_by(current_user)
    @notifications = unread_notis.group_by { |noti| noti.subject.project }
    render
  end

  def all
    notis = current_user.notifications
    @notifications = notis.group_by { |noti| noti.subject.project }
    render 'show'
  end

  def mark
    noti = Notification.find(params[:id])
    noti.mark_as_read!(for: current_user)
    head :ok
  end
end
