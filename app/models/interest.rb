class Interest < ActiveRecord::Base
	has_and_belongs_to_many :users
	
	# sort ascending	
	default_scope :order => 'name ASC'
end
