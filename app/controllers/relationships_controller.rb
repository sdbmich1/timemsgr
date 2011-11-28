class RelationshipsController < ApplicationController
  before_filter :authenticate_user!
  
  def create
    @relationship = current_user.relationships.build(:tracker_id => params[:tracker_id], :status=>'pending', :rel_type=> params[:rtype] )
    if @relationship.save
      redirect_to relationships_url, :notice => "Sent connection request."
    else
      redirect_to relationships_url, :notice => "Unable to send connection request."
    end
  end

  def index
    @user = User.find(params[:uid])
    @trackers = @user.trackers
  end
  
  def private
    @user = User.find(params[:uid])
    @trackers = @user.private_trackers   
  end
  
  def social
    @user = User.find(params[:uid])
    @trackers = @user.social_trackers   
  end
  
  def destroy
    @relationship = current_user.friendships.find(params[:id])
    @relationship.destroy
    redirect_to current_user, :notice => "Removed relationship."
  end

end
