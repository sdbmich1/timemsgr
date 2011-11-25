class ScheduledEventsController < ApplicationController
  before_filter :authenticate_user!, :except => [:create]
  before_filter :load_data
  include ResetDate, SetAssn
  layout :page_layout

  def create
    @event = ScheduledEvent.add_event(params[:id],params[:etype],@host_profile.subscriptionsourceID, params[:sdate] )
    @event.save ? flash[:notice] = "Added event to schedule." : flash[:notice] = "Unable to add event to schedule."
    redirect_to events_url
  end
  
  def edit
    @event = ScheduledEvent.find(params[:id])
    @picture = set_associations(@event.pictures, 1)
  end

  def update
    @event = ScheduledEvent.find(params[:id])
    if @event.update_attributes(reset_dates(params[:scheduled_event]))
      redirect_to events_url, :notice => "#{get_msg(@user, 'Event')}"
    else
      render :action => 'edit'
    end
  end

  def destroy
    @event = ScheduledEvent.find(params[:id])
    @event.destroy
    redirect_to events_url, :notice => "Successfully destroyed life event."
  end
    
  def clone  
    @event = ScheduledEvent.find(params[:id]).clone_event
  end
  
  private
  
  def page_layout 
    if mobile_device?
      (%w(edit new).detect { |x| x == action_name}) ? 'form' : action_name == 'show' ? 'showitem' : 'application'
    else
      "events"
    end
  end    
    
  def load_data
    @user = current_user
    @host_profile = @user.host_profiles.first
  end  
end
