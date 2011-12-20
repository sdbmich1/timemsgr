class ParentEvent < ActiveRecord::Base

    
  def ssid
    subscriptionsourceID
  end
  
  def cid
    contentsourceID
  end

  def owned?(ssid)
    self.contentsourceID == ssid
  end
  
  def get_location
    location.blank? ? '' : get_place.blank? ? location : get_place + ', ' + location 
  end
  
  def get_place
    mapplacename.blank? ? '' : mapplacename + ' '
  end
  
  def csz
    mapcity.blank? ? '' : mapstate.blank? ? mapcity : mapcity + ', ' + mapstate + ' ' + mapzip
  end
  
  def location_details
    get_location + csz
  end
  
  def same_day?
    eventstartdate == eventenddate
  end
    
  def reset_attr
    self.eventstartdate=self.eventenddate = nil
  end
  
  def start_date
    eventstartdate.strftime("%D")
  end
  
  def end_date
    eventenddate.strftime("%D")
  end
  
  def start_time
    eventstarttime.strftime('%l:%M %p')
  end
  
  def end_time
    eventendtime.strftime('%l:%M %p')    
  end
end
