class Channel < ActiveRecord::Base
	attr_accessible :title, :start_date, :location_id , :channel_status
	
	# define user & subscriptions
	has_many :subscriptions, :dependent => :destroy
	has_many :users, :through => :subscriptions
	
	has_many :channel_interests, :dependent => :destroy
	has_many :interests, :through => :channel_interests
	
	has_many :events	
	has_many :channel_locations
	
	scope :active, :conditions => { :status => 'active' }
	scope :unhidden, :conditions => { :hide => 'no' }
	scope :local, lambda { |loc| 
				  { :joins => [:channel_locations], :conditions => 
          { :channel_locations => { :location_id => loc }}} }
	scope :intlist, lambda { | f |
   				{ :joins => [:channel_interests], :conditions => 
   				{ :channel_interests => { :interest_id => f }}} }
  scope :uniquelist, :select => 'DISTINCT channels.id, channels.name'
  
  default_scope :order => 'sortkey ASC'
end
