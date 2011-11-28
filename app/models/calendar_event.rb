class CalendarEvent < KitsCentralModel
  set_table_name 'events'
  set_primary_key 'ID'
   
  default_scope :order => 'eventstartdate, eventstarttime ASC'
  
  has_many :pictures, :as => :imageable, :dependent => :destroy
  
  scope :active, where(:status.downcase => 'active')
  scope :unhidden, where(:hide.downcase => 'no')

  define_index do
    indexes :event_name, :sortable => true
    indexes :bbody, :sortable => true
    indexes :cbody, :sortable => true
    indexes :eventstartdate, :sortable => true
    indexes :eventenddate, :sortable => true
   
    has :ID, :as => :event_id
    has :event_type
    where "(status = 'active' AND hide = 'no' AND event_type NOT IN ('es', 'h', 'm'))
          AND ((eventstartdate >= curdate() ) 
                OR (eventstartdate <= curdate() and eventenddate >= curdate()) ) "
  end
  
  sphinx_scope(:datetime_first) { 
    {:order => 'eventstartdate, eventstarttime ASC'}
  }  
  
  default_sphinx_scope :datetime_first
end
