class ApplicationController < ActionController::Base
  protect_from_forgery
  
  protected
  
  def set_channels(select_ids)
    # get current user
 	  @user = User.find(current_user)
 	
 	  # reset if no selections are made
    @user.attributes = {select_ids => []}.merge(params[:user] || {})	
 
	  #update database
	  if @user.update_attributes params[:user]
		
		  # determine route based on string value
		  if select_ids == 'channel_ids' 
        	redirect_to new_associate_path
      else
     	    redirect_to new_subscription_path
		  end
    else
       flash.now[:error] = @user.errors
       respond_with(@user) do |format|
          format.html { render :action => :index }
       end
    end	
  end
end
