class Picture < KitsTsdModel
  belongs_to :imageable, :polymorphic => true
  has_attached_file :photo,
        :url => "/system/photos/:id/:style/:basename.:extension",
        :path => "/opt/kits/system/photos/:id/:style/:basename.:extension" 
        
  validates_attachment_presence :photo
#  validates_attachment_size :photo, :less_than => 2.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif', 'image/bmp']

end
