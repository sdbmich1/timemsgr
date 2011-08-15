require 'rewards'
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :load_settings, :prepare_for_mobile, :except => :destroy
  include Rewards
  
  protected
  
  def rescue_with_handler(exception)
    redirect_to '/500.html'
  end

  def method_missing(id, *args)
    redirect_to '/404.html'
  end
  
  def load_settings
    if user_signed_in?
      Time.zone = current_user.time_zone
      @credits = get_credits(current_user.id)
      @meters = get_meter_info
    end 
  end
  
  private
  
  def mobile_device?
    if session[:mobile_param]  
      session[:mobile_param] == "1"  
    else  
      request.user_agent =~ /iPhone;|Android/  
    end  
  end
  helper_method :mobile_device?
  
  def prepare_for_mobile  
    session[:mobile_param] = params[:mobile] if params[:mobile]  
    request.format = :mobile if mobile_device?  
  end  
end
