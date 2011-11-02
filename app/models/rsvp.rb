class Rsvp < KitsTsdModel
  set_primary_key 'ID'
  belongs_to :event, :primary_key=>:EventID, :foreign_key => :eventid
  
  attr_accessible :EventID, :subscriptionsourceID, :guests, :guest1name,
      :guest2name, :guest3name, :guest4name, :status, :responsedate, 
      :comment, :fullname, :inviteeid
end
