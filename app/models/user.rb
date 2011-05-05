class User < ActiveRecord::Base
 
  has_many :authentications
  
  # Include default devise modules. Others available are:
  # :token_authenticatable,  :lockable and :timeoutable
  devise :database_authenticatable, :registerable,  #:confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  # Setup accessible (or protected) attributes for your model - :password_confirmation,
  attr_accessible :email, :password,  :remember_me, :username, :login, :accept_terms,
  				  :first_name, :last_name, :birth_date, :gender, :location_id,
  				  :interest_ids, :category_ids, :channel_ids, :affiliations_attributes, 
  				  :events_attributes 
  				  
  # cities consist of many users  				  
#  belongs_to :city		
  # name format validators
  uname_regex = /\A[a-z\d]/i
  name_regex = 	/\A[a-z]/i

  # validate added fields  				  
  validates :first_name,  :presence => true,
                    :length   => { :maximum => 30 },
          			:format => { :with => name_regex }  
  validates :last_name,  :presence => true,
                    :length   => { :maximum => 30 },
          			:format => { :with => name_regex }
  validates :username, :uniqueness => true,
          			:length => { :within => 6..30 },
          			:format => { :with => uname_regex }
  validates :location_id, :presence => true
  validates :birth_date,  :presence => true  
  validates :gender,  :presence => true
  
  # define interest relationships
  has_and_belongs_to_many :interests 
 
 # has_many :categories, :through => :interests
  
  # define channel relationships
  has_many :subscriptions
  has_many :channels, :through => :subscriptions, 
  				:conditions => { :channel_status => 'active'}
  
  has_many :associates
  
  has_many :affiliations 
  accepts_nested_attributes_for :affiliations, :reject_if => lambda { |a| a[:name].blank? }
 
#  has_many :channels, :through => :categories

  has_many :user_events
  has_many :events, :through => :user_events #, :source => 'user_id'
 
  # Overrides the devise method find_for_authentication
  # Allow users to Sign In using their username or email address
  def self.find_for_authentication(conditions)
    login = conditions.delete(:login)
    where(conditions).where(["username = :value OR email = :value", { :value => login }]).first
  end

end
