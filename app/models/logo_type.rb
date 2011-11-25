class LogoType < KitsTsdModel
  scope :unhidden, where(:hide.downcase =>'no')

  default_scope :order => "sortkey ASC"

  def self.active
    unhidden.where(:status.downcase => 'active')
  end
  
  def self.logo_size(val)
    active.where('code = ?', val).first
  end
end
