class ChannelsController < ApplicationController
  before_filter :authenticate_user!
  layout :page_layout
  
  def index
    mobile_device? ? @channels = Channel.get_interests(@location, params[:interest_id]) : @channels = Channel.channel_list(@location, params[:interest_id], params[:channel_page])
  end
  
  def show
    @channel = Channel.find(params[:id])
    @events = Event.channel_events(Date.today+7.days, @channel.ssid)
  end
  
  def about
    @channel = Channel.find(params[:id])   
  end
  
  def select
    @interest = params[:interest_id]
    @channels = Channel.channel_list(@location, @interest, params[:channel_page])
  end
  
  private
  
  def page_layout 
    !mobile_device? ? 'users' : (%w(about show).detect { |x| x == action_name}) ? 'showitem' : 'application'    
  end 
end
