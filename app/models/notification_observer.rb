class NotificationObserver < ActiveRecord::Observer
  observe Notification
  include ProcessNotice

  def after_create(model)
    
    # get profile info
    usr = User.get_user(model.cid)

    # send notification to email list
    (1..5).each do |i|
      method = 'email' + i.to_s + 'address'
      model.send(method).blank? ? next : UserMailer.send_notice(model.send(method), model, usr).deliver     
    end   
    
    # process notifications
    process_notice(model, 'new')
  end
  
end