require 'rewards'
class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!, :load_data   
  respond_to :html, :json, :xml, :js
  include Rewards
  
  def load_data
    @user = current_user 
  	@loc_id = @user.location_id # used to display & select channels for users
  end

  def new  	
	  @selected_ids = @user.channel_ids
	  @channels = Channel.uniquelist.active.unhidden.local(@loc_id).intlist(@user.interest_ids)
	  respond_with(@subscription = @user.subscriptions.build)
  end  
  
  def show
  	
  end	
  
  def update

  end
  
  def create
    @user.attributes = {'channel_ids' => []}.merge(params[:user] || {})
    flash[:notice] = "#{get_msg(@user, 'Subscription')}" if @user.update_attributes(params[:user])   
    respond_with(@user, :location => new_affiliation_path) 
  end
  
  def edit
  	
  end
  
  def index
  	
  end  

end
