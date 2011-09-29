class ChannelsController < ApplicationController
  respond_to :html, :xml, :js, :mobile
  
  def index
    @categories = Category.get_active_list
  end
  
  def show
    @channel = Channel.find(params[:id])
  end
end
