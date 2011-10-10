class PrivateEventsController < ApplicationController
   before_filter :authenticate_user!, :load_data

  def index
    @event = PrivateEvent.current(params[:end_date], @host_profile.subscriptionsourceID)
  end

  def show
    @event = PrivateEvent.find(params[:id])
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
    @event = PrivateEvent.find(params[:id])
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
    @event = PrivateEvent.find(params[:id])
    @event.destroy
    redirect_to events_url, :notice => "Successfully destroyed private event."
  end
    
  def clone  
    @event = PrivateEvent.find(params[:id]).clone
  end
  
  def move
    @selected_event = Event.find_event(params[:id])
    @selected_event.contentsourceID = @host_profile.subscriptionsourceID
    @event = PrivateEvent.new(@selected_event.attributes)
    if @event.save
      redirect_to events_url, :notice => "#{get_msg(@user, 'Event')}"
    else
     # render :action => 'show'
      redirect_to :back
    end
  end
 
  private
    
  def load_data
    @enddate = Date.today+14.days
  end

end
