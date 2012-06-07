class Reminder < ActiveRecord::Base
  set_table_name "reminders"
  set_primary_key "ID"

  before_save :set_flds
  
  attr_accessible :reminder_type, :remindertext, :hide, :status, :CreateDateTime, :LastModifyDateTime, :LastModifyBy, :SubscriberID, :eventID, :eventstartdate,
          :startdate, :endtime, :starttime, :advwarningdays, :advwarninghours, :sourceID, :sourceURL, :reminder_name, :reminderURL, :localGMToffset 

  #validates_time :starttime, :presence => true, :allow_blank => false, :on_or_after => :now
             
  def self.active
    where(:status => 'active')
  end
  
  def self.unhidden
    active.where(:hide => 'no')
  end
  
  def set_flds    
    self.hide, self.status, self.CreateDateTime = "no", "active", Time.now if new_record?
    self.LastModifyDateTime, self.LastModifyBy = Time.now, "system"
    set_adv_flds
  end
  
  def set_adv_flds
    val = self.reminder_type.split(' ')[0].to_i rescue nil
    rtype = self.reminder_type.split(' ')[1]
    
    case 
    when !(rtype =~ /minute/i).nil?; self.advwarningminutes, self.advwarningdays = val, nil;
    when !(rtype =~ /hour/i).nil?; self.advwarningminutes, self.advwarningdays = val * 60, nil;
    when !(rtype =~ /day/i).nil?; self.advwarningdays, self.advwarningminutes = val, nil;
    when !(rtype =~ /week/i).nil?; self.advwarningdays, self.advwarningminutes = val * 7, nil;
    end    
  end
  
  def set_start_time sdt, tm
    val = 0 - self.reminder_type.split(' ')[0].to_i rescue nil
    rtype = self.reminder_type.split(' ')[1]
    
    # reset start date
    dt = [sdt.to_date.to_s, tm.to_time.to_s].join(' ').to_datetime
    
    case 
    when !(rtype =~ /minute/i).nil?; dt.advance(:minutes=>val)
    when !(rtype =~ /hour/i).nil?; dt.advance(:hours=>val)
    when !(rtype =~ /day/i).nil?; dt.advance(:days=>val)
    when !(rtype =~ /week/i).nil?; dt.advance(:weeks=>val)
    end
  end
  
  def getstarttime
    advwarningminutes.blank? ? starttime.advance(:days=>advwarningdays) : starttime.advance(:minutes=>advwarningminutes)
  end
end
