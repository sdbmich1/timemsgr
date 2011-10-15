class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :load_settings, :prepare_for_mobile, :except => :destroy
  include Rewards 
  include Schedule
  helper_method :mobile_device?

   
  def authenticate_user!
    session[:return_to] = request.fullpath
    super
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || session[:return_to]
#    session[:return_to] = nil
  end
  
  protected
  
  def method_missing(id, *args)
    redirect_to '/404.html'
  end

  def load_settings
    if user_signed_in?
 #     Time.zone = current_user.time_zone
      @credits = get_credits(current_user.id)
      @meters = get_meter_info     
      @user = current_user
      @host_profile = @user.host_profiles.first
    end 
  end
  
  private
  
  def mobile_device?
    if session[:mobile_param]  
      session[:mobile_param] == "1"  
    else  
      request.user_agent =~ /iPhone;|Android|Blackberry|Windows Phone/  
    end  
  end
   
  def prepare_for_mobile  
    session[:mobile_param] = params[:mobile] if params[:mobile]  
    request.format = :mobile if mobile_device?  
  end  
end
