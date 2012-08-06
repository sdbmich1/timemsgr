class EventType < ActiveRecord::Base
  default_scope :order => 'sortkey ASC'
    
  def self.active
    where(:status => 'active')
  end
  
  def self.unhidden
    active.where(:hide => 'no').sort_by{|desc| desc.description }
  end

  def descr_title
    description.titleize if description
  end    
end
