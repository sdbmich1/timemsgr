class ChannelsController < ApplicationController
  before_filter :authenticate_user!
  layout :page_layout
  
  def index
    mobile_device? ? @channels = Channel.channel_cached(@location, params[:interest_id]) : @channels = Channel.list_cached(@location, params[:interest_id], params[:channel_page])
  end
  
  def show
    @channel = Channel.find_channel(params[:id])
    @events = Event.channel_events(Date.today+7.days, @channel.ssid)
  end
  
  def about
    @channel = Channel.find_channel(params[:id])   
  end
  
  def select
    @interest = params[:interest_id]
    @channels = Channel.list_cached(@location, @interest, params[:channel_page])
  end
  
  private
  
  def page_layout 
    !mobile_device? ? 'users' : (%w(about show).detect { |x| x == action_name}) ? 'showitem' : 'list'    
  end 
end
