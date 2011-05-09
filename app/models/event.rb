class Event < ActiveRecord::Base
	attr_accessible :event_name, :title, :start_date, :end_date, :start_time,
				:end_time, :frequency, :event_type, :start_time_zone, :end_time_zone,
				:address, :city, :state, :postalcode, :country, :overview, :description, :location, 
				:photo, :user_id, :contact_name, :website, :phone, :email, :longitude, :latitude,
				:other_details, :gmaps, :activity_type
	
	has_many :calendar_events
	has_many :calendars, :through => :calendar_events
	
#	belongs_to :user, :foreign_key => :user_id
	has_many :user_events
#	has_many :users, :through => :user_events
	
#	accepts_nested_attributes_for :user_events

	has_attached_file :photo, :default_url => "/images/missing.png" #, :styles => { :small => "25x25>", :medium => "50x50>" }   
	
	validates :title, :presence => true
	validates :event_type, :presence => true
  validates :start_date, :presence => true
  validates :end_date, :presence => true
  validates :start_time, :presence => true
  validates :end_time, :presence => true
  validates :email, :email_format => true, :unless => Proc.new { |a| a.email.blank? } 
      
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png'] 
	validates_attachment_size :photo, :less_than => 1.megabyte
	
  #belongs_to :event_type, :foreign_key => "event_type"
 # belongs_to :event_page_section, :foreign_key => "event_type"
	
  default_scope :order => 'events.start_date, events.start_time ASC'
	
	scope :active, :conditions => { :status.downcase => 'active' }
	scope :is_visible?, :conditions => { :hide.downcase => 'no' }
	scope :current_events, lambda { | start_dt, end_dt |
   				  { :conditions => { :start_date.gte => start_dt, :end_date.lte => end_dt }}}
	scope :type_code, lambda {| x, y | where( :event_type.matches % x | 
			:event_type.matches % y ) }
	scope :posted, lambda { | post_dt |
   				  { :conditions => { :post_date.lte => post_dt }} }	  
   				  
  scope :current, lambda { | start_dt, end_dt | where("start_date >= date(?) and end_date <= date(?)", start_dt, end_dt)}               
  scope :current_time, lambda { | start_tm, end_tm | where("start_time >= time(?) and end_time <= time(?)", start_tm, end_tm)}
  scope :owned, lambda { | uid |
            { :conditions => { :user_id => uid }} } 
  
  before_save :set_flag 
  
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
      
  protected
  
    def set_flag
      if status.nil?
        self.status = "active" 
        self.hide = "no"
        self.cversion = "ue"
      end
    end
end
