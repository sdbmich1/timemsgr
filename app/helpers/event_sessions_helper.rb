module EventSessionsHelper
  
  def is_break?(session_type)
    (%w(wkshp cls mtg key brkout panel).detect { |x| x == session_type }).blank?
  end
  
  def list_events(elist, start_date)
    elist.select {|event| event.eventstartdate.to_date == start_date }
  end
  
  def get_date_range(event)
    sdate = event.eventstartdate.to_date
    edate = event.eventenddate.to_date
    drange = (sdate..edate).collect { |x| x }
  end
  
end
