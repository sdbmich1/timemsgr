class NotificationObserver < ActiveRecord::Observer
  observe Notification
  include ProcessNotice, UserInfo

  def before_create(model)
    
    # get profile info
    usr = User.get_user(model.cid)

    # send notification to email list
    (1..5).each do |i|
      email = model.send('email' + i.to_s + 'address')     
      DelayClassMethod.new("UserMailer", "send_notice", :params=>[email, model, usr]).delay if usr && !email.blank?
    end   
    
    # check for social network sharing & publish to user public events via oauth api
    if model.fbCircle == 'yes' && oauth_user
      event = oath_user.event!(:name => model.event_name, :start_time => model.eventstarttime, :end_time => model.eventendtime, :location => model.location)
    end
    
    # process notifications
    process_notice(model, 'new')
  end
  
end