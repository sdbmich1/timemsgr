class PromoType < KitsCentralModel
  set_table_name "promotype"

  scope :unhidden, where(:hide.downcase =>'no')

  default_scope :order => "sortkey ASC"

  def self.active
    unhidden.where(:status.downcase => 'active')
  end

  def code
    self.Code
  end

  def desc_title
    self.Description.titleize
  end
end

