class EventsController < ApplicationController
  before_filter :authenticate_user!, :load_data
  respond_to :html, :xml, :js, :mobile
  layout :page_layout
	
	def show
 		@event = Event.find_event(params[:id], params[:etype])
 		@sponsor_pages = @event.try(:sponsor_pages)
    mobile_device? ? @presenters = @event.presenters : @presenters = @event.presenters.paginate(:page => params[:presenter_page], :per_page => 15)
	end
	
	def index
    @events = Event.find_events(@enddate, @host_profile)
  end
 	
 	private
 	
 	def page_layout 
    mobile_device? ? action_name == 'show' ? 'showitem' : 'list' : "events"
  end    
 	
 	def load_data
 	  @quote = Promo.random
    params[:end_date] ? @enddate = Date.today+params[:end_date].to_i.days : @enddate = Date.today+7.days #@events.last.eventenddate
	end

end
