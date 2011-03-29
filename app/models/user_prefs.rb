class UserPrefs < ActiveRecord::Base
  attr_accessible :pref

  belongs_to :user
end
