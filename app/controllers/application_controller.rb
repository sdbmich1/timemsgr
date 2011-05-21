class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_user_time_zone

  def set_user_time_zone
    Time.zone = current_user.time_zone if user_signed_in?
  end
  
  protected
  
  def set_channels(select_ids, action_name)
    # get current user
 	  @user = current_user
 	
 	  # reset if no selections are made
 	  if select_ids != 'session_pref_ids'
      @user.attributes = {select_ids => []}.merge(params[:user] || {})
    end	
 
    debugger

	  #update database
	  if @user.update_attributes(params[:user]) 
		
		  # determine route based on string value
		  case select_ids
		  when 'channel_ids' 
        	redirect_to new_affiliation_path
      when 'interest_ids'
     	    redirect_to new_subscription_path
     	else
     	    redirect_to(home_path(@user))
		  end
    else
       flash.now[:error] = @user.errors
       respond_with(@user) do |format|
          format.html { render :action => action_name }
       end
    end	
  end
end
