class UsersInterest < ActiveRecord::Base
	belongs_to :user
	belongs_to :interest
end
