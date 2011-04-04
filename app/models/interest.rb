class Interest < ActiveRecord::Base
	belongs_to :category
	has_and_belongs_to_many :user

	# sort ascending	
	default_scope :order => 'name ASC'
end
