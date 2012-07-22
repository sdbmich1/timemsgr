class LifeEventType < ActiveRecord::Base
  set_table_name "lifeeventtype"
  
  def self.active
    where(:status => 'active')
  end
  
  def self.unhidden
    active.where(:hide => 'no')
  end

  def descr_title
    description.titleize rescue nil
  end    
  
  def self.get_type ptype
    where('Code = ?', ptype)
  end  
  
  def code
    self.Code
  end
  
  def description
    self.Description
  end
end
