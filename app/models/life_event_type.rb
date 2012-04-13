class LifeEventType < ActiveRecord::Base
  set_table_name "lifeeventtype"
  
  def descr_title
    try(:Description).titleize
  end
  
  def self.get_type ptype
    where('Code = ?', ptype)
  end  
end
