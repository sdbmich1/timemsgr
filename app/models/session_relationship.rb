class SessionRelationship < KitsTsdModel
  belongs_to :event
  belongs_to :session, :class_name => "Event"
end
