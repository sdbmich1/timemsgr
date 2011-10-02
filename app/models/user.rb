require 'rewards'
class User < ActiveRecord::Base
  include Rewards   
  before_create :set_timezone
  after_create :add_settings, :send_welcome_msg
  before_save :add_rewards
  after_save :save_rewards
    
  # Include default devise modules. Others available are:
  # :token_authenticatable,  :lockable and :timeoutable
  devise :database_authenticatable, :registerable,  #:confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  # Setup accessible (or protected) attributes for your model - :password_confirmation,
  attr_accessible :email, :password,  :remember_me, :username, :login, :accept_terms,
  				  :first_name, :last_name, :birth_date, :gender, :location_id, :time_zone,
  				  :interest_ids, :category_ids, :channel_ids, :affiliations_attributes, 
  				  :events_attributes, :host_profiles_attributes, :session_pref_ids
  				  :localGMToffset 
  				  
  # name format validators
  uname_regex = /^[-\w\._@]+$/i
  name_regex = 	/\A[a-z]/i

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
  has_many :subscriptions
  has_many :channels, :through => :subscriptions, 
  				:conditions => { :status => 'active'}
  
  has_many :associates
  
  has_many :affiliations 
  accepts_nested_attributes_for :affiliations, :reject_if => lambda { |a| a[:name].blank? }
 
  has_many :host_profiles, 
           :finder_sql => proc { "SELECT hp.* FROM `kitstsddb`.hostprofiles hp " +
           "INNER JOIN `kits_development`.users u ON hp.ProfileID=u.id " +
           "WHERE u.id=#{id}" }

  accepts_nested_attributes_for :host_profiles, :reject_if => :all_blank 
 
  has_many :user_photos
  accepts_nested_attributes_for :user_photos, :reject_if => lambda { |a| a[:photo_file_name].blank? }

  has_many :user_events
  has_many :events, :through => :user_events #, :source => 'user_id'
  
  has_many :settings
  has_many :session_prefs, :through => :settings 
  
  has_many :authentications

  # Overrides the devise method find_for_authentication
  # Allow users to Sign In using their username or email address
  def self.find_for_authentication(conditions)
    login = conditions.delete(:login)
    where(conditions).where(["username = :value OR email = :value", { :value => login }]).first
  end
  
  # add default settings for user session preferences
  def add_settings
    SessionPref.all.each do |p|
      Setting.create(:user_id => self.id, :session_pref_id => p.id)
    end
  end
  
  def add_rewards  
    @reward_amt = add_credits(self.changes) if self.changed?
  end
  
  def save_rewards    
    save_credits(self.id, 'Profile', @reward_amt) unless @reward_amt.blank? || @reward_amt == 0
  end
   
  def send_welcome_msg
     UserMailer.welcome_email(self).deliver  
  end    

  # set default time zone for new users
  def set_timezone
    loc = Location.where(["id = :value", { :value => self.location_id }]).first
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
end
