module ResetDate
  
  # used to reset date strings to rails date format

  def parse_date(old_dt)
    Date.strptime(old_dt, '%m/%d/%Y') if old_dt    
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
