class Category < ActiveRecord::Base
  attr_accessible :name
  
 # define relationships
  has_many :subcategories
  has_many :interests
  has_many :users, :through => :interests
  
  validates :name, :presence => true  #, :length => { :maximum => 15 }
 
  default_scope :order => 'categories.name ASC'
end