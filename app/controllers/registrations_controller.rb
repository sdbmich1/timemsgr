class RegistrationsController < Devise::RegistrationsController
  layout :page_layout
  
  def after_sign_up_path_for(resource)
    flash[:notice] = "#{get_msg(@user,'Welcome')}"
    new_interest_path
  end
  
  def create  
    super  
    session[:omniauth] = nil unless @user.new_record?   
  end 
  
  private
  
  def page_layout
    mobile_device? ? 'reg' : 'application'
  end
  
  def build_resource(*args)
    super
    if session[:omniauth]
      @user.apply_omniauth(session[:omniauth])
      @user.valid?
    end
  end
end
