class ReoccurrenceType < KitsCentralModel
  set_table_name 'reoccurrencetype' 
  
  default_scope :order => 'sortkey ASC'
  
  def self.active
    where(:status => 'active')
  end
  
  def self.unhidden
    active.where(:hide => 'no')
  end  
  
  def descr_title
    try(:description).titleize
  end
  
  def self.get_code(rtype)
    freq = find_by_code rtype
    freq.code
  end  
end
