class TransactionDetail < KitsTsdModel
  belongs_to :transaction

  attr_accessible :item_name, :quantity, :price
  
  validates :item_name, :presence => true
  validates :quantity, :presence => true
  validates :price, :presence => true
  
end
