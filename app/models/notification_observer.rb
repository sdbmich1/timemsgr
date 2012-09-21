class NotificationObserver < ActiveRecord::Observer
  observe Notification
  include ProcessNotice, UserInfo

  def after_create(model)
    
    # get profile info
    usr = User.get_user(model.cid)

    # send notification to email list
    (1..5).each do |i|
      method = 'email' + i.to_s + 'address'
      unless model.send(method).blank? #? next : UserMailer.delay.send_notice(model.send(method), model, usr)  
        DelayClassMethod.new("UserMailer", "send_notice", :params=>[model.send(method), model, usr]).delay 
      end  
    end   
    
    # check for social network sharing & publish to user public events via oauth api
    if model.fbCircle == 'yes' && oauth_user
      event = oath_user.event!(:name => model.event_name, :start_time => model.eventstarttime, :end_time => model.eventendtime, :location => model.location)
    end
    
    # process notifications
    process_notice(model, 'new')
  end
  
end