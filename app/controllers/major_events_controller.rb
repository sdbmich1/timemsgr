class MajorEventsController < ApplicationController
  before_filter :authenticate_user!
  
  def show
    @event = Event.find(params[:id])
  end
  
  def index
  end
end
