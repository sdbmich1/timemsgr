class RegistrationsController < Devise::RegistrationsController
  layout :page_layout
  
  def after_sign_up_path_for(resource)
    if mobile_device? 
      events_url
    else
      flash[:notice] = "#{get_msg(@user,'Welcome')}"
      new_interest_path
    end
  end
  
  private
  
  def page_layout 
    if mobile_device?
      'form' 
    else
      "application"
    end
  end  
end
