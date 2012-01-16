class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :load_settings, :prepare_for_mobile, :except => :destroy
  include Rewards, Schedule
  helper_method :mobile_device?
  
  def authenticate_user!
    session[:return_to] = request.fullpath
    super
  end

  def after_sign_in_path_for(resource)
    events_path
  end
  
  protected
  
  def rescue_with_handler(exception)
    redirect_to '/500.html'
  end       
  
  def method_missing(id, *args)
    redirect_to '/404.html'
  end

  def load_settings
    if user_signed_in?
#      Time.zone = current_user.time_zone
      @user = current_user
      @credits, @meters = get_credits(current_user.id), get_meter_info  
      params[:location] ? loc = params[:location] : loc = current_user.location_id 
      @location = Location.find_location loc
    end        
  end

  
  private
  
  def mobile_device?
    if session[:mobile_param]  
      session[:mobile_param] == "1"  
    else  
      request.user_agent =~ /iPhone;|Android|BlackBerry|Symbian|Windows Phone/  
    end  
  end
   
  def prepare_for_mobile  
    session[:mobile_param] = params[:mobile] if params[:mobile]  
    request.format = :mobile if mobile_device?  
  end  
end
