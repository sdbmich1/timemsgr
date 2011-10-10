class RegistrationsController < Devise::RegistrationsController
  
  def after_sign_up_path_for(resource)
    events_url || session[:return_to]
#    session[:return_to] = nil
  end
  
end
