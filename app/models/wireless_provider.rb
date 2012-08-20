class WirelessProvider < ActiveRecord::Base
  
  def self.active
    where(:status => 'active')
  end
  
  def self.unhidden
    active.where(:hide => 'no').sort_by{|x| x.code }
  end
  
end
