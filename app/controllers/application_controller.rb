class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :load_settings, :except => [:destroy, :clock, :getquote]
  before_filter :prepare_for_mobile, :except => :destroy
  include Rewards
  helper_method :mobile_device?
  
  def authenticate_user!
    session[:return_to] = request.fullpath
    super
  end

  def after_sign_in_path_for(resource)
    @user ||= resource
    if @user.sign_in_count <= 1 # check for new users
      new_local_subscription_path
    else
      p 'In app controller...'
      events_path
    end 
  end
  
  protected
  
#  def rescue_with_handler(exception)
#    redirect_to '/500.html'
#  end       
  
  def method_missing(id, *args)
    redirect_to '/404.html'
  end

  def load_settings
    if signed_in?
      @user ||= current_user
      @location ||= Location.find_location params[:location] || current_user.location_id
      @facebook_user = @user.get_facebook_user session[:omniauth] if session[:omniauth]
    end
  end
  
  def stored_location_for(resource)
    if current_user && params[:redirect_to]
      return params[:redirect_to]
    end
    super( resource ) 
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
