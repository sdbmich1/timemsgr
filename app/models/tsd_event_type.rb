class TsdEventType < KitsTsdModel
  set_table_name 'event_types'
  
  default_scope :order => 'sortkey ASC'
  
  def self.active
    where(:status => 'active')
  end
  
  def self.unhidden
    active.where(:hide => 'no')
  end
    
  def descr_title
    description.titleize
  end    
end
