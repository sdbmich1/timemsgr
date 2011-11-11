class Picture < KitsTsdModel
  belongs_to :imageable, :polymorphic => true
  has_attached_file :photo,
        :url => "/system/photos/:id/:style/:basename.:extension",
#        :path => ":rails_root/public/system/photos/:id/:style/:basename.:extension"
        :path => "/opt/kits/system/photos/:id/:style/:basename.:extension" 
end
