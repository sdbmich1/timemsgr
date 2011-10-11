class MajorEventsController < ApplicationController
  before_filter :authenticate_user!
  
  def show
    @event = Event.find(params[:id])
    @presenters = @event.try(:presenters)
  end
  
  def about
    @event = Event.find(params[:id])
    @presenters = @event.try(:presenters)
  end

end
