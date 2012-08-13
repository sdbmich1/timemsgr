module ResetDate
  
  # used to reset date strings to rails date format
  def self.parse_date(old_dt)
    new_dt = old_dt.split('/') if old_dt
    Date.parse([new_dt[2], new_dt[0], new_dt[1]].join('-')) if new_dt    
  end
  
  def self.convert_date(old_dt)
    Date.strptime(old_dt, '%m/%d/%Y') if old_dt    
  end   

  def self.reset_dates(val)
    if val[:"eventstarttime(5i)"]
      val[:eventstarttime] = val[:"eventstarttime(5i)"]
      val.delete(:"eventstarttime(5i)")
    end

    if val[:"eventendtime(5i)"]
      val[:eventendtime] = val[:"eventendtime(5i)"]
      val.delete(:"eventendtime(5i)")
    end

    # convert dates to rails format
    val[:eventstartdate] = parse_date(val[:eventstartdate]) if val[:eventstartdate] 
    val[:eventenddate] = parse_date(val[:eventenddate]) if val[:eventenddate]
    val[:reoccurrenceenddate] = parse_date(val[:reoccurrenceenddate]) if val[:reoccurrenceenddate]
    val
  end
end
