class ScheduledEventsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @event = ScheduledEvent.add_event(params[:id],params[:etype],@host_profile.subscriptionsourceID )
    redirect_to events_url
  end
  
end
