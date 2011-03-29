class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable,  :lockable and :timeoutable
  devise :database_authenticatable, :registerable,  #:confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model - :password_confirmation,
  attr_accessible :email, :password,  :remember_me,
  				  :first_name, :last_name, :city, :birth_date, :gender,
  				  :interest_ids 
  				  
  # cities consist of many users  				  
#  belongs_to :city			

  # validate added fields  				  
  validates :first_name,  :presence => true,
                    :length   => { :maximum => 30 }  
  validates :last_name,  :presence => true,
                    :length   => { :maximum => 30 }
  validates :city,  :presence => true,
                    :length   => { :maximum => 30 }  
  validates :birth_date,  :presence => true  
  validates :gender,  :presence => true
  
  has_and_belongs_to_many :interests                                   
end
