require 'rewards'
class User < ActiveRecord::Base
  include Rewards   
  before_create :set_timezone
  before_save :add_rewards
  after_save :save_rewards
    
  # Include default devise modules. Others available are:
  # :token_authenticatable,  :lockable and :timeoutable
  devise :database_authenticatable, :registerable,  #:confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login, :promo_code

  # Setup accessible (or protected) attributes for your model - :password_confirmation,
  attr_accessible :email, :password,  :remember_me, :username, :login, :accept_terms,
  				  :first_name, :last_name, :birth_date, :gender, :location_id, :time_zone,
  				  :interest_ids, :category_ids, :channel_ids, :affiliations_attributes, 
  				  :host_profiles_attributes, :localGMToffset, :subscription_ids, :promo_code
  				   #:session_pref_ids, :events_attributes,
  				  
  # name format validators
  uname_regex = /^[-\w\._@]+$/i
  name_regex = 	/^[A-Z]'?['-., a-zA-Z]+$/i

  # validate added fields  				  
  validates :first_name,  :presence => true,
                    :length   => { :maximum => 30 },
          			:format => { :with => name_regex }  
  validates :last_name,  :presence => true,
                    :length   => { :maximum => 30 },
          			:format => { :with => name_regex }
  validates :username, :presence => true, :uniqueness => true,  
                :allow_blank => true,
          			:length => { :within => 6..30 },
          			:format => { :with => uname_regex }
  validates :location_id, :presence => true
  validates :birth_date,  :presence => true  
  validates :gender,  :presence => true
  
  # define interest relationships
  has_and_belongs_to_many :interests 
   
  # define channel relationships
  has_many :subscriptions, :conditions => { :status => 'active'}
  has_many :channels, :through => :subscriptions, 
  				:conditions => { :status => 'active'}
  
#  has_many :events, :through => :host_profiles, :source => "subscriptionsourceID"
  has_many :transactions
  
  belongs_to :location
#  has_many :associates  
  
  has_many :affiliations 
  accepts_nested_attributes_for :affiliations, :reject_if => lambda { |a| a[:name].blank? }
 
  has_many :host_profiles, :foreign_key => :ProfileID
  accepts_nested_attributes_for :host_profiles, :reject_if => :all_blank 
      
  has_many :settings
  has_many :session_prefs, :through => :settings 
  
  has_many :authentications
  
  has_many :relationships, :foreign_key => "tracker_id", :class_name => "Relationship", :dependent => :destroy
  has_many :trackeds, :through => :relationships, :source => :tracked, :conditions => "status = 'accepted'" 
  has_many :private_trackeds, :through => :relationships, :source => :tracked, :conditions => "rel_type = 'private' AND status = 'accepted'" 
  has_many :social_trackeds, :through => :relationships, :source => :tracked, :conditions => "rel_type = 'social' AND status = 'accepted'" 
  has_many :extended_trackeds, :through => :relationships, :source => :tracked, :conditions => "rel_type = 'extended' AND status = 'accepted'"
  has_many :pending_trackeds, :through => :relationships, :source => :tracked, :conditions => "status = 'pending'", :order => :created_at
  has_many :pending_private_trackeds, :through => :relationships, :source => :tracked, :conditions => "rel_type = 'private' AND status = 'pending'"
  has_many :pending_social_trackeds, :through => :relationships, :source => :tracked, :conditions => "rel_type = 'social' AND status = 'pending'"
  has_many :pending_extended_trackeds, :through => :relationships, :source => :tracked, :conditions => "rel_type = 'extended' AND status = 'pending'"

  has_many :reverse_relationships, :foreign_key => "tracked_id", :class_name => "Relationship", :dependent => :destroy
  has_many :trackers, :through => :reverse_relationships, :source => :tracker #, :conditions => "status = 'accepted'"
  has_many :private_trackers, :through => :reverse_relationships, :source => :tracker, :conditions => "rel_type = 'private' AND status = 'accepted'"
  has_many :social_trackers, :through => :reverse_relationships, :source => :tracker, :conditions => "rel_type = 'social' AND status = 'accepted'"
  has_many :extended_trackers, :through => :reverse_relationships, :source => :tracker, :conditions => "rel_type = 'extended' AND status = 'accepted'"
  has_many :pending_trackers, :through => :reverse_relationships, :source => :tracker, :conditions => "status = 'pending'", :order => :created_at
  has_many :pending_private_trackers, :through => :reverse_relationships, :source => :tracker, :conditions => "rel_type = 'private' AND status = 'pending'"
  has_many :pending_social_trackers, :through => :reverse_relationships, :source => :tracker, :conditions => "rel_type = 'social' AND status = 'pending'"
  has_many :pending_extended_trackers, :through => :reverse_relationships, :source => :tracker, :conditions => "rel_type = 'extended' AND status = 'pending'"

  # Overrides the devise method find_for_authentication
  # Allow users to Sign In using their username or email address
  def self.find_for_authentication(conditions)
    login = conditions.delete(:login)
    where(conditions).where(["username = :value OR email = :value", { :value => login }]).first
  end
  
  def add_rewards  
    @reward_amt = add_credits(self.changes) if self.changed?
  end
  
  def save_rewards    
    save_credits(self.id, 'Profile', @reward_amt) unless @reward_amt.blank? || @reward_amt == 0
  end
   
  # set default time zone for new users
  def set_timezone
#    loc = Location.where(["id = :value", { :value => self.location_id }]).first
    loc = Location.find(self.location_id)
    self.time_zone, self.localGMToffset = loc.time_zone, loc.localGMToffset
  end
  
  # set user hash for omniauth
  def self.create_from_hash!(hash)
    create(:name => hash['user_info']['name'])
  end
  
  def apply_omniauth(omniauth)  
    self.email = omniauth['user_info']['email'] #if email.blank?  
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])  
  end
  
  def with_host_profile
    self.host_profiles.build if self.host_profiles.empty?
    self
  end
  
  def self.find_subscriber(uid)
    includes(:subscriptions => [:channel]).find(uid)
  end  
  
  def ssid
    self.host_profiles[0].subscriptionsourceID
  end
  
  def profile
    self.host_profiles[0]
  end
  
  def pictures
    profile.pictures
  end
  
  def private_events
    self.host_profiles[0].private_events
  end
  
  def scheduled_events
    self.host_profiles[0].scheduled_events    
  end

  def life_events
    self.host_profiles[0].life_events    
  end
  
  def private_circle_events
    self.host_profiles[0].private_events.private_circle   
  end
  
  def social_circle_events
    self.host_profiles[0].private_events.social_circle   
  end

  def extended_circle_events
    self.host_profiles[0].private_events.extended_circle   
  end  

end
