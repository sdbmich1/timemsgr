module EventSessionsHelper
  
  def is_break?(session_type)
    (%w(wkshp cls mtg key brkout panel).detect { |x| x == session_type }).blank?
  end
  
  def list_events(elist, start_date)
    elist.select {|event| event.eventstartdate.to_date == start_date }
  end
  
  def get_date_range(*args)
    event = args[0]    
    if args[1] 
      sdate = event.first.eventstartdate.to_date
      args[1] ? edate = args[1] : edate = sdate
    else
      sdate = event.first.eventstartdate.to_date
      edate = event.first.eventenddate.to_date
    end
    drange = (sdate..edate).collect { |x| x }
  end
  
end
