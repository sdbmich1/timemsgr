class Interest < ActiveRecord::Base
	belongs_to :category
	has_and_belongs_to_many :user
	
	has_many :channel_interests
	has_many :channels, :through => :channel_interests, 
				:conditions => { :status => 'active'}
	
	has_attached_file :photo, :styles => { :small => "25x25>" }  

  scope :unhidden, :conditions => { :hide => 'no' }
  
  def self.active
    unhidden.where(:status => 'active')
  end

	# sort ascending	
	default_scope :order => 'sortkey ASC'
end
