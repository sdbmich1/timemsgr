class ChannelLocation < ActiveRecord::Base
  belongs_to :channel
  belongs_to :location
end
