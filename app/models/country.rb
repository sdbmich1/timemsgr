class Country < KitsCentralModel
  set_table_name 'country' 
  set_primary_key 'ID'
  
  has_many :locations
  
  default_scope :order => 'sortkey ASC'
end
