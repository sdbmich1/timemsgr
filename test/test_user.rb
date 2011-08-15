module TestUser
  def make_user
    @user = User.new
    @user.first_name = 'Xavy'
    @user.last_name = 'Test'
    @user.username = 'xavy01'
    @user.birth_date = '1977-04-23'
    @user.password = 'setup#123'
    @user.gender = 'Male'
    @user.location_id = 1
    @user.email = 'xavy@test.com'
  end
  
  def make_event
    @event = Event.new
    @event.title = 'Test Event' + Time.now.to_i.to_s
    @event.event_type = 'ue'
    @event.start_date = Date.today
    @event.end_date = Date.today
    @event.start_time   =   Time.now.strftime("%I:%M%p")
    @event.end_time   =     Time.now.advance(:hours => 2).strftime("%I:%M%p")
    @event.other_details = "W Hotel"
    @event.address   =      "123 Elm"
    @event.city     =       "LA"
    @event.state   =        "CA"
    @event.postalcode  =    "90201"
    @event.status   =       "active"
    @event.event_type   =   "ue"
    @event.hide     =       "no"

  end
  
end