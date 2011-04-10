class Channel < ActiveRecord::Base
	attr_accessible :title, :start_date, :location_id , :channel_status
	
	# define user & subscriptions
	has_many :subscriptions
	has_many :users, :through => :subscriptions
	
	has_many :channel_interests
	has_many :interests, :through => :channel_interests
	
	has_many :events
	
	scope :active, :conditions => { :channel_status => 'active' }
	scope :local, lambda { |loc| { 
				:conditions => { :location_id => loc }} }
	scope :intlist, lambda { | f |
   				{ :joins => [:channel_interests], :conditions => 
   				{ :channel_interests => { :interest_id => f }}} }
   	scope :uniquelist, :select => 'DISTINCT channels.id, channels.title'
end
