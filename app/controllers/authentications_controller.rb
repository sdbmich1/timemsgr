class AuthenticationsController < ApplicationController
 
  def index
    @authentications = current_user.authentications if current_user  
  end

  def create
      auth = request.env["omniauth.auth"] 
      debugger
 #     auth = request.env["rack.omniauth"] 
      current_user.authentications.find_or_create_by_provider_and_uid(auth['provider'], auth['uid'])
      flash[:notice] = "Authentication successful."  
      redirect_to authentications_url  
  end

  def destroy
    @authentication = current_user.authentications.find(params[:id])  
    @authentication.destroy  
    flash[:notice] = "Successfully destroyed authentication."  
    redirect_to authentications_url  
  end
  
  def blank
    render :text => "Not Found.", :status => 404
  end
  
   def failure
    render :text => "Invalid route.", :status => 404
  end
end
