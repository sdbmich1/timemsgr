class NotificationObserver < ActiveRecord::Observer
  observe Notification
  include ProcessNotice, UserInfo

  def after_create(model)
    
    # get profile info
    usr = User.get_user(model.cid)

    # send notification to email list
    (1..5).each do |i|
      method = 'email' + i.to_s + 'address'
      email = model.send(method)
      unless email.blank?   
        DelayClassMethod.new("UserMailer", "send_notice", :params=>[email, model, usr]).delay if usr
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