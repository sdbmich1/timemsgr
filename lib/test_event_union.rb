module TestEventUnion
  def get_events(edt, cid)
    @sql = "(SELECT ID as id, event_name, 
        event_type, eventstartdate, eventenddate, eventstarttime, eventid, 
        eventendtime, event_title, cbody, bbody, mapplacename, localGMToffset, endGMToffset,
        mapstreet, mapcity, mapstate, mapzip, mapcountry, location, contentsourceID"
    where_dt = "where (status = 'active' and hide = 'No') 
                and (eventstartdate >= curdate() and eventstartdate <= ?) 
                or (eventstartdate <= curdate() and eventenddate >= ?) "
    where_cid = where_dt + " and (contentsourceID = ?)"

    @events = Event.find_by_sql(["#{@sql} FROM `kits_development`.eventspriv #{where_cid} ) 
         ORDER BY eventstartdate, eventstarttime ASC", edt, edt, cid]) 
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