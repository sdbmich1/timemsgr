class Frequency < ActiveRecord::Base
  default_scope :order => 'sortkey ASC'
    
  def self.active
    where(:status => 'active')
  end
  
  def self.unhidden
    active.where(:hide => 'no')
  end
  
  def self.get_freq(cd)
    find_by_name cd
  end 
  
  def self.get_code(rtype)
    freq = find_by_name rtype
    freq.code
  end
end
