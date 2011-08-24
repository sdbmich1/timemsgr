require 'kits_central'
class Promo < KitsCentralModel
  set_primary_key 'ID'
  
  scope :unhidden, :conditions => { :hide.downcase => 'no' }
  scope :getquote, :conditions => { :promo_type.downcase => 'quote' }
  
  def self.active
    unhidden.where(:status.downcase => 'active')
  end
    
  def self.random
    active.getquote.offset(rand(self.count)).first
  end
end
