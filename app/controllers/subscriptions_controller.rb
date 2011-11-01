class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!   
  respond_to :html, :json, :xml, :js
     
  def add
    @channel = Channel.find(params[:channel_id])
    @user = User.find(params[:user_id])
    @subscription = Subscription.new(:user_id=>@user.id, :channelID => @channel.channelID, :contentsourceID => @host_profile.subscriptionsourceID)
    if @subscription.save
      redirect_to events_url, :notice => "#{get_msg(@user, 'Subscription')}" 
    else
      redirect_to channel_url(@channel)
    end        
  end
  
  def index
    @user = User.find(params[:id])
    @subscriptions = @user.subscriptions
  end
  
  def cancel
    Subscription.update_all(["status='inactive'"], :id => params[:user][:subscription_ids])
    flash[:notice] = "Updated subscriptions!"  
    redirect_to home_user_path      
  end
  
  def edit
    @user = User.find(params[:id])
    @subscriptions = @user.subscriptions
  end
  
  def update
    @user = User.find(params[:id])
    @user.attributes = {'subscription_ids' => []}.merge(params[:user] || {}) 
    if @user.update_attributes(params[:user])
      redirect_to events_url, :notice  =>  "#{get_msg(@user, 'Subscription')}"
    else
      render :action => 'edit'
    end
  end

end
