require 'rewards'
class Event < ActiveRecord::Base
  include Rewards # include rewards to add credits for user where appropriate
  before_save :set_flag, :add_rewards
  after_save :save_rewards
  attr_accessor :current_user
 	attr_accessible :event_name, :title, :start_date, :end_date, :start_time,
				:end_time, :frequency, :Code, :start_time_zone, :end_time_zone,
				:address, :city, :state, :postalcode, :country, :overview, :description, :location, 
				:photo, :user_id, :contact_name, :website, :phone, :email, :longitude, :latitude,
				:other_details, :gmaps, :activity_type
	
	has_attached_file :photo, :default_url => "/images/clock_grey.png" #, :styles => { :thumb => "35x35>", :medium => "100x100>" }
	
	validates :title, :presence => true
	validates :Code, :presence => true
  validates :start_date, :presence => true
  validates :end_date, :presence => true
  validates :start_time, :presence => true
  validates :end_time, :presence => true
  validates :email, :email_format => true, :unless => Proc.new { |a| a.email.blank? } 
      
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png'] 
	validates_attachment_size :photo, :less_than => 1.megabyte
		
  default_scope :order => 'events.start_date, events.start_time ASC'
	
	scope :active, where(:status.downcase => 'active')
	scope :is_visible?, where(:hide.downcase => 'no')
	scope :posted, lambda { | post_dt |
   				  { :conditions => { :post_date.lte => post_dt }} }	    				  
  scope :current, lambda { | start_dt, end_dt | where("start_date <= date(?) and end_date >= date(?)", start_dt, end_dt)}               
  scope :current_time, lambda { | start_tm, end_tm | where("start_time >= time(?) and end_time <= time(?)", start_tm, end_tm)}
  scope :owned, lambda { | uid |
            { :conditions => { :user_id => uid }} } 
#  scope :etype, joins('JOIN event_types ON event_types.Code = events.Code')
  
  def self.upcoming(start_dt, end_dt)
    active.is_visible?.where("(start_date >= date(?) and end_date <= date(?)) or (start_date <= date(?) and end_date >= date(?))", start_dt, end_dt, start_dt, end_dt)
  end

  def self.current_events(enddate)
    active.is_visible?.upcoming(Time.now, enddate).where("start_time >= time(?) and end_time <= time(?)", Time.now, enddate)
  end  

  def add_rewards
    @reward_amt = add_credits(self.changes)
  end
  
  def save_rewards
    save_credits(self.user_id, 'Event', @reward_amt)
  end
  
  def observance?
    self.Code == "obsrv"
  end
  
  def owned?(user)
    self.user_id == user.id
  end
  
  def set_time_zone
    self.start_time_zone = current_user.time_zone unless current_user.nil?
    self.end_time_zone = current_user.time_zone unless current_user.nil?
  end
  
  def reset_attr
    self.created_at = nil
    self.updated_at = nil
    self.start_date = nil
    self.end_date = nil
  end
 
  acts_as_gmappable 
  
    def gmaps4rails_address 
      "#{address}, #{city}, #{state}, #{postalcode}"
    end

    def gmaps4rails_infowindow
      "<h3>#{title}</h3>" << "<h4>#{address}</h4>" << "#{city}, #{state}, #{postalcode}"
    end
 
    def prevent_geocoding
      address.blank? || (!latitude.blank? && !longitude.blank?) 
    end
    
    define_index do
      indexes :title, :sortable => true
      indexes :event_name, :sortable => true
      indexes :start_date, :sortable => true
      indexes :end_date, :sortable => true
    
      has :id, :event_type
    end
      
  protected
  
    def initialize(tz="Pacific Time (US & Canada)")
      super
      self.start_time_zone ||= tz
      self.end_time_zone ||= tz
    end
  
    def set_flag
      if status.nil?
        self.status = "active" 
        self.hide = "no"
        self.cversion = "ue"
       end
    end
       
end
