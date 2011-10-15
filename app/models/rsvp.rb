class RSVP < KitsSubModel
  belongs_to :event
  attr_accessible :eventid, :subscriptionsourceID
end
