class Rsvp < KitsTsdModel
  set_primary_key 'ID'
  belongs_to :event, :primary_key=>:EventID, :foreign_key => :eventid
  
  before_create :set_flds
  
  attr_accessible :EventID, :subscriptionsourceID, :email, :guests, :guest1name,
      :guest2name, :guest3name, :guest4name, :guest5name, :status, :responsedate, 
      :comment, :fullname, :inviteeid, :inviteesourceID, :inviterid, :invitersourceID
    
  name_regex =  /^[A-Z]'?['-., a-zA-Z]+$/i

  # validate added fields           
  validates :guest1name,  :allow_blank => true,
                :length => { :maximum => 60 },
                :format => { :with => name_regex }  
  validates :guest2name,  :allow_blank => true,
                :length => { :maximum => 60 },
                :format => { :with => name_regex }  
  validates :guest3name,  :allow_blank => true,
                :length => { :maximum => 60 },
                :format => { :with => name_regex }  
  validates :guest4name,  :allow_blank => true,
                :length => { :maximum => 60 },
                :format => { :with => name_regex }      
  validates :guest5name,  :allow_blank => true,
                :length => { :maximum => 60 },
                :format => { :with => name_regex }        
                
  def set_flds
    self.responsedate = Date.today
    self.CreateDateTime = Time.now
  end                      
end
