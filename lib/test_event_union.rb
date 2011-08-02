module TestEventUnion
  def get_events(edt)
    @sql = "SELECT ID as id, event_name, 
        event_type, eventstartdate, eventenddate, eventstarttime, 
        eventendtime, event_title, cbody, bbody, mapplacename, localGMToffset, endGMToffset,
        mapstreet, mapcity, mapstate, mapzip, mapcountry, location"
    @where = "where (status = 'active' and hide = 'No') 
       and ((eventstartdate >= curdate() and eventenddate <= ?) 
        or (eventstartdate <= curdate() and eventenddate >= ?)))"
#       and (eventstarttime >= curtime() and eventendtime > curtime()))"
         
    @events = Event.find_by_sql(["(#{@sql}, contentsourceID FROM `kitsnetdb`.eventspriv  
        #{@where} UNION (#{@sql}, contentsourceID FROM `kitscentraldb`.events 
        #{@where} ORDER BY eventstartdate, eventstarttime ASC", edt, edt, edt, edt])        
  end
  
  def find_event(eid)
    @sql = "(SELECT ID as id, event_name, 
        event_type, eventstartdate, eventenddate, eventstarttime, 
        eventendtime, event_title, cbody, bbody, mapplacename, 
        mapstreet, mapcity, mapstate, mapzip, mapcountry"

    @where_id = "where (id = ?))"
    @event = Event.find_by_sql(["#{@sql} FROM `kits_development`.events 
        #{@where_id} UNION #{@sql} FROM `kitscentraldb`.events #{@where_id}", eid, eid])        

  end
  
  def chk_offset(tm, offset, usroffset)
    return tm unless !offset.blank? && !usroffset.blank?
    offset == usroffset ? tm : tm = tm.advance(:hours => (usroffset - offset).to_i)
  end
  
  def is_current?(start_dt, end_tm, offset)
    etm = end_tm.advance(:hours => (0 - offset).to_i)
    start_dt <= Date.today && Time.now <= etm ? true : false    
  end
  
  def is_past?(ev)
    return false if ev.endGMToffset.blank?
    etm = ev.eventendtime.advance(:hours => (0 - ev.endGMToffset).to_i)
    ev.eventstartdate <= Date.today && Time.now > etm ? true : false    
  end
end