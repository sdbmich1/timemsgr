class ProgressMeter < ActiveRecord::Base
  
  scope :unhidden, :conditions => { :hide => 'no' }
  
  def self.active
    unhidden.where(:status => 'active')
  end

  default_scope :order => 'sortkey ASC'
end
