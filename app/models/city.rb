class City < ActiveRecord::Base
	attr_accessible :city
#	has_many :users
	
	validates :city, :presence => true, :length => { :maximum => 30 }
	default_scope :order => 'city ASC'

end
