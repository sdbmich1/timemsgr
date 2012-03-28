class User < ActiveRecord::Base
  include ResetDate, UserInfo
  acts_as_reader
   
  before_create :set_timezone
  before_destroy :clear_dependents
    
  # Include default devise modules. Others available are:
  # :token_authenticatable,  :lockable and 
  devise :database_authenticatable, :registerable, :timeoutable, #:confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login, :promo_code

  # Setup accessible (or protected) attributes for your model - :password_confirmation,
  attr_accessible :email, :password,  :remember_me, :username, :login, :accept_terms,
  				  :first_name, :last_name, :birth_date, :gender, :location_id, :time_zone, :city,
  				  :interest_ids, :category_ids, :channel_ids, :affiliations_attributes, 
  				  :host_profiles_attributes, :localGMToffset, :subscription_ids, :promo_code
  				   #:session_pref_ids
  				  
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
  validates :username, :uniqueness => true,  
                :allow_blank => true,
          			:length => { :within => 6..30 },
          			:format => { :with => uname_regex }
  validates :location_id, :presence => true
  validates :birth_date,  :presence => true  
  validates :gender,  :presence => true
  
  # define interest relationships
  has_many :user_interests, :dependent => :destroy
  has_many :interests, :through => :user_interests
   
  # define channel relationships
  has_many :subscriptions, :dependent => :destroy, :conditions => { :status => 'active'}
  has_many :channels, :through => :subscriptions, 
  				:conditions => { :status => 'active'}
  
  has_many :transactions
  
  belongs_to :location
  
  has_many :affiliations, :dependent => :destroy 
  accepts_nested_attributes_for :affiliations, :reject_if => lambda { |a| a[:name].blank? }
 
  # support legacy db user profile data
  has_many :host_profiles, :dependent => :destroy, :foreign_key => :ProfileID
  accepts_nested_attributes_for :host_profiles, :reject_if => :all_blank 
      
  has_many :settings, :dependent => :destroy
  has_many :session_prefs, :dependent => :destroy, :through => :settings 
  
  has_many :authentications, :dependent => :delete_all
  
  # define friend relationships
  has_many :relationships, :foreign_key => "tracker_id", :class_name => "Relationship", :dependent => :destroy
  has_many :trackeds, :through => :relationships, :source => :tracked, :conditions => "status = 'accepted'" 
  has_many :private_trackeds, :through => :relationships, :source => :tracked, :conditions => "rel_type = 'private' AND status = 'accepted'" 
  has_many :social_trackeds, :through => :relationships, :source => :tracked, :conditions => "rel_type = 'social' AND status = 'accepted'" 
  has_many :extended_trackeds, :through => :relationships, :source => :tracked, :conditions => "rel_type = 'extended' AND status = 'accepted'"

  # define pending friend relationships
  has_many :pending_trackeds, :through => :relationships, :source => :tracked, :conditions => "status = 'pending'", :order => :created_at
  has_many :pending_private_trackeds, :through => :relationships, :source => :tracked, :conditions => "rel_type = 'private' AND status = 'pending'"
  has_many :pending_social_trackeds, :through => :relationships, :source => :tracked, :conditions => "rel_type = 'social' AND status = 'pending'"
  has_many :pending_extended_trackeds, :through => :relationships, :source => :tracked, :conditions => "rel_type = 'extended' AND status = 'pending'"

  # define reverse friend relationships
  has_many :reverse_relationships, :foreign_key => "tracked_id", :class_name => "Relationship", :dependent => :destroy
  has_many :trackers, :through => :reverse_relationships, :source => :tracker, :conditions => "status = 'accepted'"
  has_many :private_trackers, :through => :reverse_relationships, :source => :tracker, :conditions => "rel_type = 'private' AND status = 'accepted'"
  has_many :social_trackers, :through => :reverse_relationships, :source => :tracker, :conditions => "rel_type = 'social' AND status = 'accepted'"
  has_many :extended_trackers, :through => :reverse_relationships, :source => :tracker, :conditions => "rel_type = 'extended' AND status = 'accepted'"

  # define reverse pending friend relationships
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
  
  def dbname
    Rails.env.development? ? "`kits_development`" : "`kits_production`"
  end  
  
  def timeout_in
    7.days
  end 
     
  # set default time zone for new users
  def set_timezone
    loc = Location.find(self.location_id)
    self.time_zone, self.localGMToffset = loc.time_zone, loc.localGMToffset
  end

  def clear_dependents
    self.interests.delete
  end
  
  # set user hash for omniauth
  def self.create_from_hash!(hash)
    create(:name => hash['user_info']['name'])
  end
  
  def apply_omniauth(omniauth)  
    self.email = omniauth['user_info']['email'] #if email.blank?  
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])  
  end
  
  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.first_name = auth["user_info"]["name"].split(' ')[0]
      user.last_name = auth["user_info"]["name"].split(' ')[1]
    end
  end
  
  def get_facebook_user(access_token)
    @fb_user ||= FbGraph::User.me(access_token.credentials.token).fetch
  end
  
  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token.extra.raw_info
#    debugger
    if user = User.where(:email => data.email).first
      user
    else # Create a user with a stub password. 
      user = User.new(:first_name => data.first_name, :last_name => data.last_name, 
        :username => data.username ? data.username : data.nickname, :birth_date => ResetDate.convert_date(data.birthday),
        :location_id => get_location(data.location.name.split(', ')[0]), :city => data.location.name,
        :localGMToffset => data.timezone.to_i, :gender => data.gender.capitalize, :email => data.email, 
        :password => Devise.friendly_token[0,20])   
      UserInfo.oauth_user = user.get_facebook_user access_token          
      user.save(:validate => false)  
      user
    end
  end
   
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"]
      end
    end
  end
  
  def password_required?  
    (authentications.empty? || !password.blank?) && super  
  end   
  
  def with_host_profile
    self.host_profiles.build if self.host_profiles.empty?
    self
  end
  
  def self.find_subscriber(uid)
    includes(:subscriptions => [:local_channel]).find(uid)
  end  
  
  def self.get_location(city)
    loc = Location.find_by_city city
    loc.id if loc
  end

  def profile
    self.host_profiles.build if self.host_profiles.empty?
    self.host_profiles[0]
  end
    
  def ssid
    profile.subscriptionsourceID
  end
  
  def pictures
    profile.pictures
  end
  
  def prof_id
    profile.ProfileID
  end
  
  def hostname
    profile.HostName
  end
  
  def name
    [first_name, last_name].join(' ')
  end
  
  def location
    loc = Location.find(location_id)
    loc.city
  end
  
  def self.get_user(sid)
    HostProfile.get_user(sid)  
  end
  
  def host_name
    profile.HostName
  end
  
  def private_events
    profile.private_events
  end
  
  def promoCode
    profile.promoCode
  end
  
  def scheduled_events
    profile.scheduled_events    
  end

  def life_events
    profile.life_events    
  end
  
  def private_circle_events
    profile.private_events.private_circle   
  end
  
  def social_circle_events
    profile.private_events.social_circle   
  end

  def extended_circle_events
    profile.private_events.extended_circle   
  end 
  
  def city
    profile.City
  end
  
  def self.add_initial_subscriptions
    self.interest_ids.each do |i|
      interest = Interest.find(i).name rescue nil
      
      # find correct channel based on location
      cid = LocalChannel.select_channel(interest, user.profile.City, user.location) if interest
      cid.map {|channel| Subscription.create(:user_id=>self.id, :channelID => channel.channelID, :contentsourceID => self.ssid) } if cid   
    end        
  end 
  
  # define sphinx search indexes and criteria
  define_index do
    indexes :first_name, :sortable => true
    indexes :last_name, :sortable => true
    indexes [first_name, last_name], :as => :name, :sortable => true
   
    has :id, :as => :user_id
  end 
   
  sphinx_scope(:name_first) { 
    {:order => 'last_name, first_name ASC'}
  }  
  
  default_sphinx_scope :name_first
end
