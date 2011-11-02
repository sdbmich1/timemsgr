class ReoccurrenceType < KitsCentralModel
  set_table_name 'reoccurrencetype' 
  
  default_scope :order => 'sortkey ASC'
  
  def descr_title
    try(:description).titleize
  end
end
