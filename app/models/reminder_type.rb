class ReminderType < KitsTsdModel
  set_table_name "remindertype"

  default_scope :order => 'sortkey ASC'
  
  def self.active
    where(:status => 'active')
  end
  
  def self.unhidden
    active.where(:hide => 'no')
  end
  
  def descr_title
    description.titleize if description
  end
  
  def self.get_description ptype
    rt = ReminderType.find_by_code ptype
    rt.description if rt
  end  
end
