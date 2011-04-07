class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!

  def new
  	# used to display & select channels for users
  	@loc_id = 1
  	
  	# set user
  	@user = current_user 
  	
  	# check channel ids
	@selected_ids = @user.channel_ids
	
	# get channels for user based on location
	@channels = Channel.joins(:channel_interests).where(
			:channels => {:location_id => @loc_id}, 
			:channel_interests => {:interest_id => @user.interest_ids})
  end  
  
  def show
  	
  end	
  
  def update
  	
  end
  
  def edit
  	
  end
end
