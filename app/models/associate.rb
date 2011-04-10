class Associate < ActiveRecord::Base
  attr_accessible :name, :email, :user_id
	
  belongs_to :user
	
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

#  validates :email, :presence => true,
#                    :format   => { :with => email_regex }
  validates :email, :presence => true, :email_format => true                    
end
