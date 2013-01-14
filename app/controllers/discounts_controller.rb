class DiscountsController < ApplicationController
  
  def index
    @discount = PromoCode.get_code(params[:promo_code], Date.today)
  end
    
end
