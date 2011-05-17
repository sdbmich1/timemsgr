class HostProfile < ActiveRecord::Base
  belongs_to :user, :foreign_key => :user_id
  
  attr_accessible :address1, :city, :state, :postalcode, :country, :address2,
  :home_phone, :work_phone, :cell_phone, :title, :company, :industry,
  :nationality, :ethnicity, :hide, :status, :user_id 
    
#  phone_regex = /^(?:(?:\+?1\s*(?:[.-]\s*)?)?(?:\(\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\s*\)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\s*(?:[.-]\s*)?)?([2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\s*(?:[.-]\s*)?([0-9]{4})(?:\s*(?:|x\.?|ext\.?|extension)\s*(\d+))?$/

#  validates :home_phone, :format => { :with => phone_regex },
 #           :unless => Proc.new { |a| a.home_phone.blank? } 
 # validates :work_phone, :format => { :with => phone_regex },
 #           :unless => Proc.new { |a| a.work_phone.blank? }
 # validates :cell_phone, :format => { :with => phone_regex },
 #           :unless => Proc.new { |a| a.cell_phone.blank? }

end