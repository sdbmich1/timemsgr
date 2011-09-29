class BrowseMenu < ActiveRecord::Base

  scope :unhidden, where(:hide.downcase => 'no' )
  
  def self.active
    unhidden.where(:status.downcase => 'active')
  end
  
  def self.findmenu(menutype)
    active.where(:menutype => menutype)
  end
  
  default_scope :order => 'sortkey ASC'

end
