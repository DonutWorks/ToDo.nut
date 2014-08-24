class NotificationsController < ApplicationController
  def show
    unread_activities = PublicActivity::Activity.unread_by(current_user)
    @notifications = unread_activities.group_by { |activity| activity.trackable.project }
    render
  end

  def all
    activities = PublicActivity::Activity.with_read_marks_for(current_user)
    @notifications = activities.group_by { |activity| activity.trackable.project }
    render 'show'
  end

  def mark
    activity = PublicActivity::Activity.find(params[:id])
    activity.mark_as_read!(for: current_user)
    head :ok
  end
end
