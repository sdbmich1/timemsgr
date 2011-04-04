class Event < ActiveRecord::Base
	belongs_to :user
	belongs_to :interest
	belongs_to :interest_category
	belongs_to :channel
	
end
