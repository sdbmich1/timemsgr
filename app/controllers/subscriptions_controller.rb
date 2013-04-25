class SubscriptionsController < ApplicationController
  before_filter :authenticate_user!, :except => [:create]   
  layout :page_layout
  
  def create
    @user ||= User.find(params[:user_id])
    @channel = ThinkingSphinx.search params[:channel_id], :classes => [LocalChannel, Channel]
    @subscription = Subscription.new_member(@user, @channel)
    if @subscription.save
      redirect_to categories_url, :notice => "#{get_msg(@user, 'Subscription')}" 
    else
      respond_to do |format|
        format.html { redirect_to(categories_url) } 
        format.mobile { redirect_to channel_url(@channel) }
      end
    end        
  end
  
  def update
    @user ||= User.find(params[:user_id])
    @channel = LocalChannel.find_by_channelID(params[:channel_id])
    @subscription = Subscription.unsubscribe(params[:user_id], params[:channel_id])
    if @subscription.save
      redirect_to subscriptions_url(:id=>@user), :notice => 'Successfully unsubscribed from channel ' + @channel.channel_name 
    else
      respond_to do |format|
        format.html { redirect_to subscriptions_url(:id=>@user) } 
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
    mobile_device? ? (%w(edit new).detect { |x| x == action_name}) ? 'form' : action_name == 'show' ? 'showitem' : 'list' : "showevent"
  end    
end
