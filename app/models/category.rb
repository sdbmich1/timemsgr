class Category < ActiveRecord::Base
  attr_accessible :name, :photo
  
  has_many :subcategories
  has_many :interests
#  has_many :users, :through => :interests

  has_many :channel_interests, :through => :interests
  has_many :channels, :through => :channel_interests
  has_many :events, :through => :channels
          
  validates :name, :presence => true  #, :length => { :maximum => 15 }
  
  has_attached_file :photo, :styles => { :small => "25x25>" },  
  	:url => "/images/:attachment/:id/:style/:basename.:extension",  
  	:path => ":rails_root/public/images/:attachment/:id/:style/:basename.:extension"  

  scope :unhidden, :conditions => { :hide => 'no' }
  default_scope :order => 'sortkey ASC'
  
  def self.get_active_list
    unhidden.where(:status => 'active')
  end
  
end