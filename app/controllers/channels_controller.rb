class ChannelsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :xml, :js, :mobile
  layout :page_layout
  
  def index
    @channels = Channel.get_interests(@user.location_id, params[:interest_id])
  end
  
  def show
    @channel = Channel.find(params[:id])
    @events = Event.channel_events(Date.today+7.days, @channel.subscriptionsourceID)
  end
  
  def about
    @channel = Channel.find(params[:id])   
  end
  
  private
  
  def page_layout 
    if mobile_device?
      (%w(about show).detect { |x| x == action_name}) ? 'showitem' : 'application'
    end
  end 
end
