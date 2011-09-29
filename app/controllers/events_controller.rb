class EventsController < ApplicationController
   before_filter :authenticate_user!, :except => [:index]
   before_filter :load_data
   respond_to :html, :xml, :js, :mobile
	
	def show
	  if @slider
	    (@slider =~ /Channel/i).nil? ? @event = Event.find_event(params[:id]) : @event = Event.find(params[:id])
	  else
	    @event = Event.find_event(params[:id])
	  end 
 		respond_with(@event)
	end
	
	def index
    params[:end_date] ? @enddate = Time.now+14.days : @enddate = Time.now+params[:end_date].to_i.days 
    user_signed_in? ? @events = Event.current(@enddate, @user.id.to_s) : @events = Event.current_events(@enddate)
    respond_with(@events)
 	end
	
	protected

  def load_data
    @user = current_user
    @slider = params[:slider] if params[:slider] # used to define sliders for mobile app
  end

end
