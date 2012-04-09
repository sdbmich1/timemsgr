class ChannelsController < ApplicationController
  before_filter :authenticate_user!
  layout :page_layout
  
  def index
    mobile_device? ? @channels = LocalChannel.channel_cached(@location, params[:interest_id]) : @channels = LocalChannel.get_channel_by_loc(@user.location)  #Channel.list_cached(@location, params[:interest_id], params[:channel_page])
  end
  
  def show
    @channel = LocalChannel.find_channel(params[:id])
    @events = Event.channel_events(Date.today+7.days, @channel.ssid)
  end
  
  def about
    @channel = LocalChannel.find_channel(params[:id])   
  end
  
  def select
    @interest = Interest.find params[:interest_id]
    @channels = LocalChannel.select_channel(@interest.name, @location.city, @user.location)[0].paginate(:page => params[:channel_page], :per_page => 15 )
#    @channels = Channel.list_cached(params[:location], @interest, 1)
 #   @channels = LocalChannel.get_channel(@interest.name, @location.city, @user.location).paginate(:page => params[:channel_page], :per_page => 15 )
  end
  
  private
  
  def page_layout 
    !mobile_device? ? 'users' : (%w(about show).detect { |x| x == action_name}) ? 'showitem' : 'list'    
  end 
end
