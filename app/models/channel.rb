class Channel < ActiveRecord::Base
	belongs_to :interest
	belongs_to :interest_category
	has_many :events
end
