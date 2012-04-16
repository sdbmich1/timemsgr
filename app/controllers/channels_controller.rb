class ChannelsController < ApplicationController
  before_filter :authenticate_user!
  layout :page_layout
  
  def index
    @channels = LocalChannel.get_channel_by_loc(@user.location)  
  end
  
  def show
    @channel = LocalChannel.find_channel(params[:id])
    @events = @channel.current_events
  end
  
  def about
    @channel = LocalChannel.find_channel(params[:id])   
  end
  
  def select
    @interest = Interest.find params[:interest_id]
    @channels = LocalChannel.select_channel(@interest.name, @location.city, @user.location)[0].paginate(:page => params[:page], :per_page => 15 )
  end
  
  private
  
  def page_layout 
    !mobile_device? ? 'users' : (%w(about show).detect { |x| x == action_name}) ? 'showitem' : 'list'    
  end 
end
