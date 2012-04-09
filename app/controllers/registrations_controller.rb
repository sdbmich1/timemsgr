class RegistrationsController < Devise::RegistrationsController
  layout :page_layout
  
  def after_sign_up_path_for(resource)
#    if mobile_device? 
#      events_url
#    else
      flash[:notice] = "#{get_msg(@user,'Welcome')}"
      new_interest_path
#    end
  end
  
  def create  
    super  
    session[:omniauth] = nil unless @user.new_record?   
  end 
  
  private
  
  def build_resource(*args)
    super
    if session[:omniauth]
      @user.apply_omniauth(session[:omniauth])
      @user.valid?
    end
  end

  def page_layout 
    if mobile_device?
      'form' 
    else
      "application"
    end
  end  
end
