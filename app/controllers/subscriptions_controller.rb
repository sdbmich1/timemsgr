class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!, :load_data   
  respond_to :html, :json, :xml, :js
  
  def load_data
    @user = current_user 
  	@loc_id = @user.location_id # used to display & select channels for users
  end

  def new  	
	  @selected_ids = @user.channel_ids
	  @channels = Channel.intlist(@loc_id, @user.interest_ids)
	  respond_with(@subscription = @user.subscriptions.build)
  end  
   
  def create
    @user.attributes = {'channel_ids' => []}.merge(params[:user] || {})
    flash[:notice] = "#{get_msg(@user, 'Subscription')}" if @user.update_attributes(params[:user])   
    respond_with(@user, :location => new_affiliation_path) 
  end
  
  def index
    redirect_to new_affiliation_path
  end

end
