class ObservanceEventsController < ApplicationController
   before_filter :authenticate_user!, :load_data

  def show
    @event = ObservanceEvent.find_event(params[:id])
  end

  def new
    @event = ObservanceEvent.new(:eventstartdate=>Date.today, :eventenddate=>Date.today)
  end

  def create
    @event = ObservanceEvent.new(params[:observance_event])
    if @event.save
      redirect_to private_events_url, :notice => "#{get_msg(@user, 'Event')}"
    else
      render :action => 'new'
    end
  end

  def edit
    @event = ObservanceEvent.find(params[:id])
  end

  def update
    @event = ObservanceEvent.find(params[:id])
    if @event.update_attributes(params[:observance_event])
      redirect_to @event, :notice  =>  "#{get_msg(@user, 'Event')}"
    else
      render :action => 'edit'
    end
  end

  def destroy
    @event = ObservanceEvent.find(params[:id])
    @event.destroy
    redirect_to observance_events_url, :notice => "Successfully destroyed Observance event."
  end
    
  def clone  
    @event = ObservanceEvent.find(params[:id]).clone
  end
 
  private
    
  def load_data
    @user = current_user
    @host_profile = @user.host_profiles.first
  end

end
