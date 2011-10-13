class EventsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]
  respond_to :html, :xml, :js, :mobile
	
	def show
 		respond_with(@event = Event.find_event(params[:id]))
	end
	
	def index
	  ssid = @host_profile.try(:subscriptionsourceID)
    @events = Event.find_events(params[:end_date], ssid)
 	end

end
