class Calendar < ActiveRecord::Base
	has_many :calendar_events
	has_many :events, :through => :calendar_events
end
