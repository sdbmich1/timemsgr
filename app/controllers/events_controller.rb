class EventsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]
  before_filter :load_data
  respond_to :html, :xml, :js, :mobile
	
	def show
 		respond_with(@event = Event.find_event(params[:id]))
	end
	
	def index
    respond_with(@events = Event.find_events(params[:end_date], @host_profile))
 	end
	
	def destroy
    @event = Event.find_event(params[:id])    
    @event.destroy
    redirect_to events_url, :notice => "Successfully destroyed event."
  end
  
	protected

  def load_data
 #   @slider = params[:slider] if params[:slider] # used to define sliders for mobile app
  end

end
