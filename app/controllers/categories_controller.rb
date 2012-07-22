require 'will_paginate/array'
class CategoriesController < ApplicationController
  before_filter :authenticate_user!
  layout :page_layout
  respond_to :html, :json, :xml, :js, :mobile
  
  def index
    @categories = Category.get_active_list
    @channels = LocalChannel.get_channel_by_loc(@location.city).paginate(:page => params[:page], :per_page => offset) 
    respond_with(@channels)
  end
  
  def list
    @catid, @interests = params[:category_id], Category.find(params[:category_id]).interests
    @channels = LocalChannel.pick_channels(@interests, @location.city, @user.location).paginate(:page => params[:page], :per_page => offset)
  end

  private
  
  def page_layout 
    mobile_device? ? 'pages' : "users"
  end
  
  def offset
    mobile_device? ? 30 : 15
  end 
    
end
