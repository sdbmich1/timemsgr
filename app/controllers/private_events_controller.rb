class PrivateEventsController < ApplicationController
  before_filter :authenticate_user!, :load_data
  layout :page_layout

  def index
    @events = PrivateEvent.get_events(@host_profile.subscriptionsourceID)
  end

  def show
    @event = PrivateEvent.find_event(params[:id])
    @presenters = @event.try(:presenters)
    @sponsor_pages = @event.try(:sponsor_pages)
  end

  def new
    @event = PrivateEvent.new
  end

  def create
    @event = PrivateEvent.new(params[:private_event])
    if @event.save
      redirect_to events_url, :notice => "#{get_msg(@user, 'Event')}"
    else
      render :action => 'new'
    end
  end

  def edit
    @event = PrivateEvent.find_event(params[:id])
  end

  def update
    @event = PrivateEvent.find(params[:id])
    if @event.update_attributes(params[:private_event])
      redirect_to events_url, :notice  =>  "#{get_msg(@user, 'Event')}"
    else
      render :action => 'edit'
    end
  end

  def destroy
    @event = PrivateEvent.find_event(params[:id])
    @event.destroy
    redirect_to events_url, :notice => "Successfully destroyed private event."
  end
    
  def clone  
    @event = PrivateEvent.find_event(params[:id]).clone_event
  end
 
  private
  
  def page_layout 
    if mobile_device?
      (%w(edit new).detect { |x| x == action_name}) ? 'form' : 'application'
    else
      "private_events"
    end
  end    
    
  def load_data
    @user = current_user
    @host_profile = @user.host_profiles.first
    @enddate = Date.today+14.days
  end

end
