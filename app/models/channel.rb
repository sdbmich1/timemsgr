class Channel < ActiveRecord::Base
	attr_accessible :title, :start_date, :location_id , :channel_status
	
	# define user & subscriptions
	has_many :subscriptions
	has_many :users, :through => :subscriptions
	
	has_many :channel_interests
	has_many :interests, :through => :channel_interests
	
	has_many :events
end
