require 'kits_central'
class Country < KitsCentralModel
  set_table_name 'country' 
  
  default_scope :order => 'sortkey ASC'
end
