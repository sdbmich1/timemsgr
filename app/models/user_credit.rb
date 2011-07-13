class UserCredit < ActiveRecord::Base
  attr_accessible :user_id, :context, :credits
end
