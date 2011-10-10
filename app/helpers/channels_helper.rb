module ChannelsHelper
  
  def get_event_list(elist)
    elist.reject {|e| !(%w(se es sm).detect { |x| x == e.event_type }).blank? || 
            e.status != 'active' || e.eventenddate < Date.today || 
            (e.eventstartdate <= Date.today && e.eventendtime > Time.now)}   
  end
end
