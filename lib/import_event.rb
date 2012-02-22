module ImportEvent
  
  def import
    @form = "import_event"
#   render :partial => "form"
  end
  
  # import events from google calendar for user
  def gcal_import  
    @email = params[:user][:email] # grab login parameters & authenticate
    @pwd = params[:user][:password]

    gservice = GCal4Ruby::Service.new # initialize service
    gservice.authenticate(@email, @pwd)
    @events = GCal4Ruby::Event.find(gservice, "") # grab events
      
    add_import_events # add import events to db
    redirect_to events_url  # redisplay events
  end
  
  def add_import_events
    @events.each do |e|
      if !e.title.blank? && e.start_time >= Time.now 
        
        @start, @end = e.start_time.strftime("%I:%M%p"), e.end_time.strftime("%I:%M%p")
         
        PrivateEvent.create!(:event_name => e.title, :event_type => 'ue', :eventstartdate => e.start_time, 
          :eventstarttime => @start, :eventenddate => e.end_time, :eventendtime => @end, 
          :location => e.where, :contentsourceID => @user.ssid)
      end
    end
  end
end