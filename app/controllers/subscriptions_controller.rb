class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!   
  respond_to :html, :json, :xml, :js
     
  def new
    @channel = Channel.find(params[:channel_id])
    @subscription = @user.subscriptions.build(:channelID => @channel.channelID, :contentsourceID => @host_profile.subscriptionsourceID)
    if @subscription.save
      redirect_to channels_url, :notice => "#{get_msg(@user, 'Subscription')}" 
    else
      redirect_to channel_url(@channel)
    end        
  end
  
  def edit
    @user = User.find(params[:id])
    @subscriptions = @user.subscriptions
  end
  
  def update
    @user.attributes = {'subscription_ids' => []}.merge(params[:user] || {}) 
    if @user.update_attributes(params[:user])
      redirect_to home_url, :notice  =>  "#{get_msg(@user, 'Subscription')}"
    else
      render :action => 'edit'
    end
  end

end
