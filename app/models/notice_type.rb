class NoticeType < ActiveRecord::Base
  
  before_save :set_flds
  
  default_scope :order => "code ASC"
  
  def self.active
    where(:status => 'active') 
  end
  
  def self.unhidden
    active.where(:hide => 'no')
  end
  
  def self.find_types(etype)
    unhidden.where('event_type = ?', etype)
  end
  
  def code_title
    code.titleize
  end
  
  def descr_title
    description.titleize
  end
  
  def set_flds
    self.status, self.hide = 'active', 'no'
  end
  
  def self.get_type(code)
    find_by_code(code)
  end
  
  def self.get_description(code)
    get_type(code).description
  end
end
