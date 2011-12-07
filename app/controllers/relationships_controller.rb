class RelationshipsController < ApplicationController
  before_filter :authenticate_user!, :except => [:create]
  before_filter :load_data
  layout :page_layout

  def create
    @relationship = Relationship.new(:tracked_id => current_user.id, :tracker_id => params[:trk_id], :status=>'pending', :rel_type=> params[:rtype] )
    if @relationship.save
      redirect_to relationships_url(:id=>current_user), :notice => "Connection request sent."
    else
      redirect_to relationships_url(:id=>current_user), :notice => "Unable to send connection request."
    end
  end

  def index
    @user = User.includes(:host_profiles).find(params[:id])
    @trackers = @user.trackers
    @trackeds = @user.trackeds  
  end
  
  def private
    @user = User.find(params[:id])
    @trackers = @user.private_trackers   
    @trackeds = @user.private_trackeds  
  end
  
  def social
    @user = User.find(params[:id])
    @trackers = @user.social_trackers   
    @trackeds = @user.social_trackeds  
  end
  
  def extended
    @user = User.find(params[:id])
    @trackers = @user.extended_trackers   
    @trackeds = @user.extended_trackeds  
  end  
  
  def pending
    @user = User.find(params[:id])
    @trackers = @user.pending_trackers 
    @trackeds = @user.pending_trackeds  
  end
  
  def update
    @user = User.find(params[:id])
    @relationship = Relationship.set_status(params[:tracker_id], params[:tracked_id], params[:status])
    if @relationship.save
      redirect_to relationships_url(:id=>@user) 
    else
      render :action => 'pending'
    end  
  end
  
  def destroy
    @relationship = Relationship.find_by_tracker_id(params[:trk_id])
    @relationship.destroy
    redirect_to relationships_path(:id=>params[:id]), :notice => "Removed relationship."
  end
  
  protected
  
  def page_layout  
    mobile_device? ? "application" : "users"  
  end 
  
  def load_data
    @rel_type = params[:rtype]
  end

end
