class InterestsUser < ActiveRecord::Base
	attr_accessible :interest
	
	belongs_to :user
	belongs_to :interest
	
	has_many :interests_categories_users

end
