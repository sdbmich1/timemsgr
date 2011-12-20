class Notification < ActiveRecord::Base
  set_primary_key 'ID'
  
  before_save :set_flds
  
  attr_accessible :event_type, :email1address, :email2address, :email3address, :email4address, :email5address, 
  :eventid, :event_id, :event_name,
  :eventstartdate, :eventstarttime, :eventenddate, :eventendtime, :Notice_Type, :Notice_Text, 
  :allowPrivCircle, :allowSocCircle, :allowWorldCircle, :status, :hide, :sortkey, :CreateDateTime,
  :LastModifyBy, :LastModifyDateTime, :contentsourceID, :subscriptionsourceID, :location
  
  email_regex = /[\w-]+@([\w-]+\.)+[\w-]+/i

  validates :event_type, :presence => true
  validates :contentsourceID, :presence => true
  validates :email1address, :format => email_regex, :unless => Proc.new { |a| a.email1address.blank? }
  validates :email2address, :format => email_regex, :unless => Proc.new { |a| a.email2address.blank? }
  validates :email3address, :format => email_regex, :unless => Proc.new { |a| a.email3address.blank? }
  validates :email4address, :format => email_regex, :unless => Proc.new { |a| a.email4address.blank? }
  validates :email5address, :format => email_regex, :unless => Proc.new { |a| a.email5address.blank? }
  
  def cid
    contentsourceID
  end
  
  def start_date
    eventstartdate.strftime("%D")
  end
  
  def end_date
    eventenddate.strftime("%D")
  end
  
  def start_time
    eventstarttime.strftime('%l:%M %p')
  end
  
  def end_time
    eventendtime.strftime('%l:%M %p')    
  end

  def message
    self.Notice_Text.titleize if self.Notice_Text
  end
  
  def title
    self.Notice_Type.titleize
  end
  
  def set_flds
    ntype = NoticeType.get_type(self.Notice_Type, self.event_type)
    self.Notice_Text = ntype.description if ntype
    self.CreateDateTime = Time.now
    self.Notice_ID = self.Notice_Type[0..1] + Time.now.to_i.to_s if self.Notice_ID.blank? 
  end
end
