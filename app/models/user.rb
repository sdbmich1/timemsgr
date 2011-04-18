class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable,  :lockable and :timeoutable
  devise :database_authenticatable, :registerable,  #:confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model - :password_confirmation,
  attr_accessible :email, :password,  :remember_me,
  				  :first_name, :last_name, :birth_date, :gender, :location_id,
  				  :interest_ids, :category_ids, :channel_ids, :affiliations_attributes 
  				  
  # cities consist of many users  				  
#  belongs_to :city			

  # validate added fields  				  
  validates :first_name,  :presence => true,
                    :length   => { :maximum => 30 }  
  validates :last_name,  :presence => true,
                    :length   => { :maximum => 30 }
#  validates :city,  :presence => true,
#                    :length   => { :maximum => 30 }  
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

end
