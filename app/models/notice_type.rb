class NoticeType < ActiveRecord::Base
  
  before_save :set_flds
  
  default_scope :order => "sortkey ASC"
  
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
    self.status = 'active'
    self.hide = 'no'
  end
  
  def self.get_type(code, etype)
    find_by_code_and_event_type(code, etype)
  end
  
  def self.get_description(code, etype)
    get_type(code, etype).description
  end
end
