class EventsController < ApplicationController
  before_filter :authenticate_user!, :load_data
  respond_to :html, :xml, :js, :mobile
  layout :page_layout
	
	def show
 		@event = Event.find_event(params[:id], params[:etype])
		@presenters = @event.try(:presenters)
 		@sponsor_pages = @event.try(:sponsor_pages)
	end
	
	def index
    @events = Event.find_events(params[:end_date], @host_profile)
 	end
 	
 	private
 	
 	def page_layout 
    if mobile_device?
      action_name == 'show' ? 'showitem' : 'application'
    else
      "events"
    end
  end    
 	
 	def load_data
 	  @quote = Promo.random
 	end

end
