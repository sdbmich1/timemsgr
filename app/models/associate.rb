class Associate < ActiveRecord::Base
  attr_accessible :name, :email, :user_id
	
  belongs_to :user
	
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

#  validates :email, :presence => true,
#                    :format   => { :with => email_regex }
  validates :email, :email_format => true, :message => "Email must have valid format"     
  
  after_create :send_invites
  
  def send_invites
   	 UserMailer.invite_friends(self).deliver  
  end               
end
