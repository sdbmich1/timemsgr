class ContactDetail < KitsTsdModel
  belongs_to :contactable, :polymorphic => true
end
