class EventsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]
  respond_to :html, :xml, :js, :mobile
	
	def show
 		respond_with(@event = Event.find_event(params[:id]))
	end
	
	def index
    respond_with(@events = Event.find_events(params[:end_date], @host_profile))
 	end

end
