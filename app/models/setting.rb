class Setting < ActiveRecord::Base
  belongs_to :session_pref
  belongs_to :user
end
