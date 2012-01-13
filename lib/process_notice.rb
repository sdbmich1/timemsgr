module ProcessNotice
 
  def process_notice(model, ptype)
    
    # get profile info
    usr = User.get_user(model.cid)
    
    # get trackers based on type    
    unless usr.blank? 
      [['private_trackers', 'allowPrivCircle'], ['social_trackers', 'allowSocCircle'], ['extended_trackers', 'allowWorldCircle']].each do |method|
        trkrs = usr.send(method[0]) if model.send(method[1])
        post_notice(trkrs, model, usr, ptype) if trkrs
      end
    end
  end
    
  def key_field?(fld)
    (%w(eventstartdate eventenddate eventstarttime).detect { |x| x == fld})
  end
  
  def newuser_notice(model)
    # add notice
    enotice = EventNotice.create( :Notice_Type=>'welcome',:Notice_Text=>"Welcome to Koncierge, #{model.first_name}. Your account has been created.", 
            :sourceID=>model.ssid, :subscriberID=>model.ssid, :Notice_ID=>'cu' + model.id.to_s )  
  end
  
  def other_notice(model, ptype)
    # get profile info
    usr = User.find model.tracked_id
    
    # get tracker info
    trkr = User.find(model.tracker_id)

    # add notice
    enotice = EventNotice.create( :Notice_Type=>ptype,:Notice_Text=>usr.name + ' has ' + ptype + 'ed a connection with you.', 
            :sourceID=>trkr.ssid, :subscriberID=>usr.ssid, :Notice_ID=>'cr' + model.id.to_s )

    #also send email to person
    UserMailer.send_request(trkr.email, enotice, usr).deliver unless trkr.email.blank? 
  end
    
  def post_notice(ary, model, usr, ptype)
    ary.each do |trkr|
      enotice = EventNotice.create(:eventid=>model.eventid, :event_name=>model.event_name, :event_type=>model.event_type,
            :eventstartdate=>model.eventstartdate, :eventenddate=>model.eventenddate, :Notice_Type=>get_notice_type(model, ptype),
            :Notice_Text=>get_notice_text(model, ptype), :eventstarttime=>model.eventstarttime, :eventendtime=>model.eventendtime,
            :sourceID=>trkr.ssid, :subscriberID=>model.contentsourceID, :Notice_ID=>get_notice_id(model), :location=>get_location(model),
            :event_id=>get_event_id(model) )
      
      #also send email to each person
      trkr.email.blank? ? next : UserMailer.send_notice(trkr.email, enotice, usr).deliver     
    end
  end
  
  def notification?(model)
    model.class.to_s == "Notification" 
  end
  
  def get_notice_type(model, ptype)
    notification?(model) ? model.Notice_Type : ptype == 'new'? 'schedule' : ptype == 'update'? 'reschedule' : ptype
  end
  
  def get_notice_text(model, ptype)
    notification?(model) ? model.Notice_Text : NoticeType.get_description(get_notice_type(model, ptype)) 
  end
  
  def get_notice_id(model)
    notification?(model) ? model.Notice_ID : model.eventid    
  end
  
  def get_event_id(model)
    notification?(model) ? model.event_id : model.ID 
  end

  def get_location(model)
    notification?(model) ? model.location : model.location_details
  end  
end