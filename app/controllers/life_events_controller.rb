class LifeEventsController < ApplicationController
  before_filter :authenticate_user!
  include ResetDate

  def show
    @event = LifeEvent.find(params[:id])
  end

  def new
    @event = LifeEvent.new(:eventstartdate=>Date.today, :eventenddate=>Date.today)
  end

  def create
    @event = LifeEvent.new(reset_dates(params[:life_event]))
    if @event.save
      redirect_to events_url, :notice => "#{get_msg(@user, 'Event')}"
    else
      render :action => 'new'
    end
  end

  def edit
    @event = LifeEvent.find(params[:id])
  end

  def update
    @event = LifeEvent.find(params[:id])
    if @event.update_attributes(reset_dates(params[:life_event]))
      redirect_to events_url, :notice => "#{get_msg(@user, 'Event')}"
    else
      render :action => 'edit'
    end
  end

  def destroy
    @event = LifeEvent.find(params[:id])
    @event.destroy
    redirect_to events_url, :notice => "Successfully destroyed life event."
  end
    
  def clone  
    @event = LifeEvent.find(params[:id]).clone_event
  end

end
