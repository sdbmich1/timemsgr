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