module ChannelsHelper
  
  def get_event_list(elist)
     elist.reject {|e| !(%w(se es sm).detect { |x| x == e.event_type }).blank? || !time_left?(e) }   
  end
  
  def subscribed?(slist, cid)
    slist.detect { |x| x.channelID == cid && x.status == 'active' }   
  end
end
