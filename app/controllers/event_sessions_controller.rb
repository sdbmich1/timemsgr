class EventSessionsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @event = Event.get_event_details(params[:event_id])
  end

  def show
    @event = Event.find(params[:id])
    @presenters = @event.presenters
  end

  def new
    @session = EventSession.new
  end

  def create
    @session = EventSession.new(params[:session])
    if @session.save
      redirect_to @session, :notice => "Successfully created session."
    else
      render :action => 'new'
    end
  end

  def edit
    @session = EventSession.find(params[:id])
  end

  def update
    @session = EventSession.find(params[:id])
    if @session.update_attributes(params[:session])
      redirect_to @session, :notice  => "Successfully updated session."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @session = EventSession.find(params[:id])
    @session.destroy
    redirect_to sessions_url, :notice => "Successfully destroyed session."
  end
end
