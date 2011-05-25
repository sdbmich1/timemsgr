class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!
    
#  respond_to :html, :json, :xml

  def new
 	
  	# set user
  	@user = current_user 
  	
  	# used to display & select channels for users
  	@loc_id = @user.location_id
  	
   	#set subscriptions
  	@subscription = Subscription.new
  	
  	# check channel ids
	  @selected_ids = @user.channel_ids
	
	  # get channels for user based on location
	  @channels = Channel.uniquelist.active.unhidden.local(@loc_id).intlist(@user.interest_ids)
	
#	respond_with(@subscription)
  end  
  
  def show
  	
  end	
  
  def update

  end
  
  def create
  	set_channels('channel_ids', 'index')
  end
  
  def edit
  	
  end
  
  def index
  	
  end  

end
