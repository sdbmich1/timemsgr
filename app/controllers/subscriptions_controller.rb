class SubscriptionsController < ApplicationController
  before_filter :authenticate_user! #, :except => [:create]   
  layout :page_layout
  
  def create
    @channel = LocalChannel.find(params[:channel_id])
    @user ||= User.find(params[:user_id])
    @subscription = Subscription.new_member(@user, @channel)
    if @subscription.save
      redirect_to events_url, :notice => "#{get_msg(@user, 'Subscription')}" 
    else
      respond_to do |format|
        format.html { redirect_to(categories_url) } 
        format.mobile { redirect_to channel_url(@channel) }
      end
    end        
  end
  
  def update
    @channel = LocalChannel.find(params[:channel_id])
    @subscription = Subscription.unsubscribe(params[:user_id], @channel.channelID)
    if @subscription.save
      redirect_to events_url 
    else
      respond_to do |format|
        format.html { redirect_to categories_url } 
        format.mobile { redirect_to channel_url(@channel) }
      end
    end  
  end 
  
  def index
    @user = User.find_subscriber(params[:id])
    @subscriptions = @user.subscriptions.paginate(:page => params[:page], :per_page => 15)
  end
  
  def new
    @subscription = @user.subscriptions.build
    @subscriptions = @user.subscriptions.paginate(:page => params[:page], :per_page => 15)  
    @credits, @meters = get_credits(current_user.id), get_meter_info 
  end
  
  private
  
  def page_layout 
    mobile_device? || action_name == 'new' ? "application" : "events"
  end    
end
