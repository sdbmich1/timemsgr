class EventsController < ApplicationController
   before_filter :authenticate_user!, :except => [:index]
   before_filter :load_data
   respond_to :html, :xml, :js, :mobile
	
	def show
 		respond_with(@event = Event.find_event(params[:id]))
	end
	
	def index
    respond_with(@events = Event.find_events(params[:end_date], @user))
 	end
	
	protected

  def load_data
    @user = current_user
    @slider = params[:slider] if params[:slider] # used to define sliders for mobile app
  end

end
