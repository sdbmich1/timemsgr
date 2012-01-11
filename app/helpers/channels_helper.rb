module ChannelsHelper
  
  def get_event_list(elist)
     elist.reject {|e| !(%w(se es sm).detect { |x| x == e.event_type }).blank? || e.eventenddate < Date.today }   
  end
  
  def subscribed?(slist, cid)
    slist.detect { |x| x.channelID == cid && x.status == 'active' }   
  end
  
  def get_subscription(slist, cid)
    sub = slist.detect { |x| x.channelID == cid && x.status == 'active' } 
    sub  
  end  
end
