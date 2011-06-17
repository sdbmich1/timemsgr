require 'win32ole'
module ImportEvent
  
  def import
    @form = "import_event"
#   render :partial => "form"
  end
  
  # import events from google calendar for user
  def gcal_import
    # initialize service
    gservice = GCal4Ruby::Service.new
    
    # grab login parameters & authenticate
    @email = params[:user][:email]
    @pwd = params[:user][:password]

    gservice.authenticate(@email, @pwd)
    
    # grab events
    @events = GCal4Ruby::Event.find(gservice, "")
  
    # add import events to db
    add_import_events
    
    # redisplay events
    redirect_to events_url   
  end
  
  def outlook
    outlook = WIN32OLE.new('Outlook.Application')   
    mapi = outlook.GetNameSpace('MAPI') # get MAPI namespace
        
    # get default mapi calendar folder
    @calendar = mapi.GetDefaultFolder(9)
    
    @form = "outlook_import"
  end
  
  def add_import_events
    @events.each do |e|
      if !e.title.blank? && e.start_time >= Time.now 
        
        @start = e.start_time.strftime("%I:%M%p")
        @end = e.end_time.strftime("%I:%M%p")
        
        debugger
        
        Event.create!(:title => e.title, :event_type => 'ue', :start_date => e.start_time, 
          :start_time => @start, :state => 'IL', :end_date => e.end_time, :end_time => @end, :address => e.where,
          :location => e.where, :user_id => @user.id)
      end
    end
  end
end