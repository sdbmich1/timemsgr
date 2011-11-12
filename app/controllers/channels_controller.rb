class ChannelsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :xml, :js, :mobile
  
  def index
    @channels = Channel.get_interests(@user.location_id, params[:interest_id])
  end
  
  def show
    @channel = Channel.find(params[:id])
    @events = Event.channel_events(Date.today+14.days, @channel.subscriptionsourceID)
  end
  
  def about
    @channel = Channel.find(params[:id])   
  end
end
