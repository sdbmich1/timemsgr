class EventsController < ApplicationController
  before_filter :authenticate_user!, :except => [:clock, :getquote] 
  before_filter :load_data, :only => :index
  before_filter :chk_notices, :only => [:index, :notice]
  respond_to :html, :xml, :js, :mobile
  layout :page_layout
	
	def show
 		@event = Event.find_event params[:id], params[:etype], params[:eid], params[:sdt]
 		@sponsor_pages = @event.sponsor_pages rescue nil 
    @sessions = @event.sessions.paginate(:page => params[:session_page], :per_page => 15) rescue nil
 		@presenters = @event.presenters.paginate(:page => params[:presenter_page], :per_page => 15) rescue nil
 		@notification = Notification.new
	end
	
	def index
    @events = Event.find_events @enddate, @user
    @nearby_events = @user.nearby_events location, @enddate
  end
  
  def notify
    @event_type = params[:etype]
  end
  
  def notice
    EventNotice.mark_as_read! :all, :for => @user    
  end
  
  def getquote
    @quote = Promo.random
  end
	
 	protected
 	
 	def page_layout 
    mobile_device? ? action_name == 'show' ? 'showitem' : 'events' : action_name == 'show' ? 'showevent' : "events"
  end    
  
  def chk_notices
    @notices = EventNotice.get_notices(@user.ssid).paginate(:page => params[:notice_page], :per_page => 10)   
  end
 	
 	def load_data
    @credits, @meters = get_credits(current_user.id), get_meter_info  
    @enddate = params[:end_date] ? Date.today+params[:end_date].to_i.days : Date.today+7.days 
    PrivateEvent.add_facebook_events @facebook_user, @user if @facebook_user
	end
	
	def location
	  @location.city
	end

end
