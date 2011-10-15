class RsvpsController < ApplicationController
  def index
    @rsvps = RSVP.all
  end

  def show
    @rsvp = RSVP.find(params[:id])
  end

  def new
    @rsvp = RSVP.new
  end

  def create
    @rsvp = RSVP.new(params[:rsvp])
    if @rsvp.save
      redirect_to @rsvp, :notice => "Successfully created rsvp."
    else
      render :action => 'new'
    end
  end

  def edit
    @rsvp = RSVP.find(params[:id])
  end

  def update
    @rsvp = RSVP.find(params[:id])
    if @rsvp.update_attributes(params[:rsvp])
      redirect_to @rsvp, :notice  => "Successfully updated rsvp."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @rsvp = RSVP.find(params[:id])
    @rsvp.destroy
    redirect_to rsvps_url, :notice => "Successfully destroyed rsvp."
  end
end
