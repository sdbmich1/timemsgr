class Location < ActiveRecord::Base
  has_many :channel_locations
end
