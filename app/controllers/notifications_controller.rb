class NotificationsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @notification = Notification.new(params[:notification])
    if @notification.save
      flash[:notice] = "Notification request sent."
    else
      flash[:notice] = "Unable to send notification request."
    end
  end
end
