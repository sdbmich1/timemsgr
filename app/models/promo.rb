require 'kits_central'
class Promo < KitsCentralModel
  set_primary_key 'ID'
  
  scope :unhidden, :conditions => { :hide => 'no' }
  scope :getquote, :conditions => { :promo_type => 'quote' }
  
  def self.active
    unhidden.where(:status => 'active')
  end
    
  def self.random
    active.getquote.offset(rand(self.count)).first
  end
end
