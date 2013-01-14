class PromoCode < KitsTsdModel
  belongs_to :promoable, :polymorphic => true
  
  def self.active
    where(:status => 'Active') 
  end
  
  def self.chk_date result, dt
    if result.promoenddate.to_date >= dt && dt <= result.promostartdate.to_date 
      result
    else
      nil
    end
  end
  
  def self.get_code cd, dt
    result = active.find_by_code cd
    chk_date result, dt if result
  end
end
