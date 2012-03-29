class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # set user
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
    session[:omniauth] = request.env["omniauth.auth"]
    if @user
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
  
  def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end
  
  def setup
    request.env['omniauth.strategy'].options[:display] = mobile_device? ? "touch" : "page"
    render :text => "Setup complete.", :status => 404    
  end
end