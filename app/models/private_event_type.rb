class PrivateEventType < ActiveRecord::Base
  set_table_name 'event_types'
  
  def self.get_type ptype
    where('code = ?', ptype)
  end
end
