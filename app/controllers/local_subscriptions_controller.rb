class LocalSubscriptionsController < ApplicationController
  before_filter :authenticate_user!   
  layout :page_layout
  respond_to :html, :json, :xml, :js

  def new
    @subscription = @user.subscriptions.build
    @subscriptions = @user.subscriptions.paginate(:page => params[:page], :per_page => 15)  
    @credits, @meters = get_credits(current_user.id), get_meter_info 
  end

  def create
#    @subscription = @user.subscriptions.new
    @user.attributes = {'subscription_ids' => []}.merge(params[:user] || {})
    unless @user.update_attributes(params[:user])
      @credits, @meters = get_credits(current_user.id), get_meter_info
    end
    respond_with(@user, :location => events_path) 
  end
    
  private
  
  def page_layout 
    if action_name == 'new'  
      mobile_device? ? "form" : "application"
    else
      mobile_device? ? "list" : "events"
    end
  end    
end
