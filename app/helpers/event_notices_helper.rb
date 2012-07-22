module EventNoticesHelper
  
  def get_past_notices
    min_date = Date.today.advance(:days => -13)
    nlist = @notices.select {|notice| notice.created_at.to_date < min_date}
    nlist
  end
  
  def get_recent_notices
    min_date = Date.today.advance(:days => -13)
    nlist = @notices.select {|notice| notice.created_at.to_date >= min_date}
    nlist    
  end
end
