class ChannelsController < ApplicationController
  respond_to :html, :xml, :js, :mobile
  
  def index
    loc = 4
    @channels = Channel.get_list(loc, params[:interest_id])
  end
  
  def show
    @channel = Channel.find(params[:id])
    @events = Event.channel_events(Date.today+14.days, @channel.subscriptionsourceID)
  end
  
  def about
    @channel = Channel.find(params[:id])   
  end
end
