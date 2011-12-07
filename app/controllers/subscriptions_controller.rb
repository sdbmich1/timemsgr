class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!, :except => [:create, :unsubscribe]   
#  respond_to :html, :json, :xml, :js
  layout :page_layout
  
  def create
    @channel = Channel.find(params[:channel_id])
    @user = User.find(params[:user_id])
    @subscription = Subscription.new_member(@user, @channel)
    if @subscription.save
      redirect_to events_url, :notice => "#{get_msg(@user, 'Subscription')}" 
    else
      redirect_to channel_url(@channel)
    end        
  end
  
  def unsubscribe
    @channel = Channel.find_by_channelID(params[:channel_id])
    @subscription = Subscription.find_subscription(params[:user_id], params[:channel_id])
    if @subscription.save
      redirect_to events_url 
    else
      redirect_to channel_url(@channel)
    end  
  end 
  
  def index
    @user = User.find_subscriber(params[:id])
    @subscriptions = @user.subscriptions
  end
  
  private
  
  def page_layout 
    mobile_device? ? "application" : "events"
  end    
end
