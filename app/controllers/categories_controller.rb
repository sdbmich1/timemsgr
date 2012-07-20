require 'will_paginate/array'
class CategoriesController < ApplicationController
  before_filter :authenticate_user!
  layout :page_layout
  respond_to :html, :json, :xml, :js, :mobile
  
  def index
    @categories = Category.get_active_list
    @channels = LocalChannel.get_channel_by_loc(@location.city).paginate(:page => params[:page], :per_page => 15) 
    respond_with(@channels)
  end
  
  def list
    @catid, @interests = params[:category_id], Category.find(params[:category_id]).interests
    @channels = LocalChannel.pick_channels(@interests, @location.city, @user.location).paginate(:page => params[:page], :per_page => 15 )
  end

  private
  
  def page_layout 
    mobile_device? ? 'list' : "users"
  end 
    
end
