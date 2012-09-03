class InterestsUser < ActiveRecord::Base
	attr_accessible :interest	
	
	belongs_to :user
	belongs_to :interest
	
end
