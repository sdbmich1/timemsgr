class RelationshipsController < ApplicationController
  before_filter :authenticate_user! #, :except => [:create, :update] 
  before_filter :load_data
  layout :page_layout

  def create
    @user = User.find(params[:id])
    @relationship = Relationship.new(:tracked_id =>params[:id], :tracker_id =>params[:trkr_id], :status=>'pending', :rel_type=> params[:rtype] )
    if @relationship.save
      redirect_to relationships_url(:id=>@user), :notice => "Connection request sent."
    else
      redirect_to relationships_url(:id=>@user), :notice => "Unable to send connection request."
    end
  end

  def index
    @user = User.includes(:host_profiles).find(params[:id])
    @trackers, @trackeds = @user.trackers, @user.trackeds | @user.pending_trackeds
  end
  
  def private
    @user = User.find(params[:id])
    @trackers, @trackeds = @user.private_trackers, @user.private_trackeds  | @user.pending_private_trackeds 
  end
  
  def social
    @user = User.find(params[:id])
    @trackers, @trackeds = @user.social_trackers, @user.social_trackeds  | @user.pending_social_trackeds 
  end
  
  def extended
    @user = User.find(params[:id])
    @trackers, @trackeds = @user.extended_trackers, @user.extended_trackeds | @user.pending_extended_trackeds
  end  
  
  def pending
    @user = User.find(params[:id])
    @trackers, @trackeds = @user.pending_trackers, @user.pending_trackeds
  end
  
  def update
#    @user = User.find(params[:id])
    @relationship = Relationship.set_status(params[:trkr_id], params[:id])
    if @relationship.save
      redirect_to relationships_url(:id=>params[:trkr_id]), :notice => "Updated relationship." 
    else
      render :action => 'pending'
    end  
  end
  
  def destroy
    @relationship = Relationship.get_relationship(params[:id], params[:trkr_id])
    @relationship.destroy
    redirect_to relationships_url(:id=>params[:trkr_id]), :notice => "Removed relationship."
  end
  
  protected
  
  def page_layout  
    mobile_device? ? "pages" : "users"  
  end 
  
  def load_data
    @rel_type = params[:rtype]
  end

end
