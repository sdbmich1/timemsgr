class SessionPref < ActiveRecord::Base
  
  # define user & instances
  has_many :settings
  has_many :users, :through => :settings
end
