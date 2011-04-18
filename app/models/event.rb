class Event < ActiveRecord::Base
	attr_accessible :event_name, :title, :start_date, :end_date, :start_time,
				:end_time, :frequency
	
	has_many :calendar_events
	has_many :calendars, :through => :calendar_events
	
	has_many :user_events
	has_many :users, :through => :user_events, :source => 'event_id'
	
	validates :title, :presence => true
	validates :start_date, :presence => true
	validates :end_date, :presence => true
	
	scope :active, :conditions => { :status.downcase => 'active' }
	scope :is_visible?, :conditions => { :hide.downcase => 'no' }
	scope :current_events, lambda { | start_dt, end_dt |
   				  { :conditions => { :start_date.gte => start_dt, :end_date.lte => end_dt }}}
	scope :type_code, lambda {| x, y | where( :event_type.matches % x | 
			:event_type.matches % y ) }
	scope :posted, lambda { | post_dt |
   				  { :conditions => { :post_date.lte => post_dt }} }	  	
end
