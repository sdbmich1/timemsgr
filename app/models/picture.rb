class Picture < KitsTsdModel
  belongs_to :imageable, :polymorphic => true
  has_attached_file :photo
end
