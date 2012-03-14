class EventsController < ApplicationController
  before_filter :authenticate_user! 
  before_filter :load_data, :only => :index
  before_filter :chk_notices, :only => [:index, :notice]
  respond_to :html, :xml, :js, :mobile
  layout :page_layout
	
	def show
 		@event = Event.find_event params[:id], params[:etype], params[:eid], params[:sdt]
 		@sponsor_pages, @presenters = @event.sponsor_pages, @event.presenters rescue nil
 		@notification = Notification.new
	end
	
	def index
    @events = Event.find_events @enddate, @user, @location
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
    mobile_device? ? action_name == 'show' ? 'showitem' : 'list' : action_name == 'show' ? 'showevent' : "events"
  end    
  
  def chk_notices
    @notices = EventNotice.get_notices(@user.ssid).paginate(:page => params[:notice_page], :per_page => 10)   
  end
 	
 	def load_data
    @credits, @meters = get_credits(current_user.id), get_meter_info  
    params[:end_date] ? @enddate = Date.today+params[:end_date].to_i.days : @enddate = Date.today+7.days 
    PrivateEvent.add_facebook_events @facebook_user, @user if @facebook_user
	end

end
