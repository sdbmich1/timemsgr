class EventsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]
  before_filter :load_data
  respond_to :html, :xml, :js, :mobile
	
	def show
 		@event = Event.find_event(params[:id], params[:etype])
 		@sponsor_pages = @event.try(:sponsor_pages)
	end
	
	def index
    respond_with(@events = Event.find_events(params[:end_date], @host_profile))
 	end
 	
 	private
 	
 	def load_data
 	  @quote = Promo.random
 	end

end
