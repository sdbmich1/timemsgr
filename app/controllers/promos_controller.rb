class PromosController < ApplicationController
  before_filter :authenticate_user! 
  respond_to :html, :xml, :js, :mobile
  layout :page_layout
  
  def show
    @promo = Promo.find params[:id]
  end

  private

  def page_layout 
    action_name == 'show' ? mobile_device? ? 'showitem' : 'showevent' : "events"
  end    

end
