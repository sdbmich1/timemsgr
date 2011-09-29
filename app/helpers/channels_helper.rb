module ChannelsHelper
  
  def get_event_list(elist)
    elist.reject {|e| e.event_type == 'se' || e.event_type == 'sm' || e.status != 'active'}
  end
end
