class RelationshipsController < ApplicationController
  before_filter :authenticate_user!
  
  def create
    @relationship = current_user.relationships.build(:tracker_id => params[:tracker_id])
    if @relationship.save
      flash[:notice] = "Added connection."
      redirect_to home_user_url
    else
      flash[:notice] = "Unable to add connection."
      redirect_to home_user_url
    end
  end

  def index
    @user = User.find(params[:id])
  end

end
