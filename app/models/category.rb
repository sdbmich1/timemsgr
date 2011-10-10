class Category < ActiveRecord::Base
#  attr_accessible :name, :photo
  
#  has_many :subcategories
  has_many :interests

  has_many :channel_interests, :through => :interests
  has_many :channels, :through => :channel_interests
  has_many :events, :through => :channels
           
#  has_attached_file :photo, :styles => { :small => "25x25>" },  
#  	:url => "/images/:attachment/:id/:style/:basename.:extension",  
#  	:path => ":rails_root/public/images/:attachment/:id/:style/:basename.:extension"  

  scope :unhidden, where(:hide.downcase => 'no')
  default_scope :order => 'sortkey ASC'

  def self.get_active_list
    unhidden.where(:status.downcase => 'active')
  end
  
end