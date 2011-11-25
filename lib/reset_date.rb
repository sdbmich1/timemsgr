module ResetDate

  def parse_date(old_dt)
    sdate = old_dt.to_s.split('/')
    new_dt = Date.parse(sdate.last + '-' + sdate.first + '-' + sdate.second)    
  end   

  def reset_dates(val)
    if val[:"eventstarttime(5i)"]
      val[:eventstarttime] = val[:"eventstarttime(5i)"]
      val.delete(:"eventstarttime(5i)")
    end

    if val[:"eventendtime(5i)"]
      val[:eventendtime] = val[:"eventendtime(5i)"]
      val.delete(:"eventendtime(5i)")
    end

    unless mobile_device?
      val[:eventstartdate] = parse_date(val[:eventstartdate]) if val[:eventstartdate] 
      val[:eventenddate] = parse_date(val[:eventenddate]) if val[:eventenddate]
    end 
    val
  end
end
