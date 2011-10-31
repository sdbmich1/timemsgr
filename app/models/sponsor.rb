class Sponsor < KitsTsdModel
  belongs_to :sponsorable, :polymorphic => true

  has_many :pictures, :as => :imageable, :dependent => :destroy
end
