class RsvpsController < ApplicationController
  before_filter :authenticate_user!
  layout :page_layout

  def show
    @event = Event.find_event(params[:eid], params[:etype]) if params[:eid]
    @rsvp = Rsvp.find_event(params[:id], @event.cid)
  end

  def new
    @event = Event.find_event(params[:eid], params[:etype]) if params[:eid]
    @rsvp = Rsvp.new(@event.attributes)
  end

  def create  
    @rsvp = Rsvp.new(params[:rsvp])
    if @rsvp.save
      add_to_schedule if params[:rsvp][:status] == 'Attending'
      redirect_to rsvp_url(:id=>@rsvp.EventID, :eid=>@event, :etype=>@event.event_type), :notice => "Successfully created rsvp."
    else
      render :action => 'new'
    end
  end

  def edit
    @event = Event.find_event(params[:eid], params[:etype]) if params[:eid]
    @rsvp = Rsvp.find(params[:id])
  end

  def update
    @rsvp = Rsvp.find(params[:id])
    if @rsvp.update_attributes(params[:rsvp])
      redirect_to @rsvp, :notice => "Successfully updated rsvp."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @rsvp = Rsvp.find(params[:id])
    @rsvp.destroy
    redirect_to rsvps_url, :notice => "Successfully destroyed rsvp."
  end
  
  private
  
  def page_layout 
    mobile_device? ? (%w(edit new).detect { |x| x == action_name}) ? 'form' : 'application' : 'application'
  end  
    
  def add_to_schedule
    @event = ScheduledEvent.add_event(@event,@event.event_type,@user.ssid )
    @event.save 
  end
end
