class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!   
  respond_to :html, :json, :xml, :js
     
  def add
    @channel = Channel.find(params[:channel_id])
    @user = User.find(params[:user_id])
    @subscription = Subscription.new(:user_id=>@user, :channelID => @channel.channelID, :contentsourceID => @host_profile.subscriptionsourceID)
#    @subscription = @user.subscriptions.build(:channelID => @channel.channelID, :contentsourceID => @host_profile.subscriptionsourceID)
    if @subscription.save
      redirect_to channel_url(@channel), :notice => "#{get_msg(@user, 'Subscription')}" 
    else
      redirect_to channel_url(@channel)
    end        
  end
  
  def edit
    @subscriptions = Subscription.get_active_list(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    @user.attributes = {'subscription_ids' => []}.merge(params[:user] || {}) 
    if @user.update_attributes(params[:user])
      redirect_to home_url, :notice  =>  "#{get_msg(@user, 'Subscription')}"
    else
      render :action => 'edit'
    end
  end

end
