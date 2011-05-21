class EventPhoto < ActiveRecord::Base
  belongs_to :event
  
  has_attached_file :photo, :default_url => "/images/missing.png", :styles => { :thumb => "35x35>", :medium => "100x100>" }

  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png'] 
  validates_attachment_size :photo, :less_than => 4.megabyte

end
