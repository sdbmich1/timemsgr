class PrivateEventsController < ApplicationController
   before_filter :authenticate_user!, :load_data

  def index
    @events = PrivateEvent.get_current_events
  end

  def show
    @event = PrivateEvent.find_event(params[:id])
  end

  def new
    @event = PrivateEvent.new
  end

  def create
    @event = PrivateEvent.new(params[:private_event])
    if @event.save
      redirect_to @event, :notice => "#{get_msg(@user, 'Event')}"
    else
      render :action => 'new'
    end
  end

  def edit
    @event = PrivateEvent.find(params[:id])
  end

  def update
    @event = PrivateEvent.find(params[:id])
    if @event.update_attributes(params[:private_event])
      redirect_to @event, :notice  =>  "#{get_msg(@user, 'Event')}"
    else
      render :action => 'edit'
    end
  end

  def destroy
    @event = PrivateEvent.find(params[:id])
    @event.destroy
    redirect_to private_events_url, :notice => "Successfully destroyed private event."
  end
    
  def clone  
    @event = PrivateEvent.find(params[:id]).clone
  end
 
  private
    
  def load_data
    @user = current_user
    @host_profile = @user.host_profiles.first
  end

end
