class HostProfilesController < ApplicationController
  before_filter :authenticate_user!
  layout :page_layout
  respond_to :html, :json, :xml, :js, :mobile

  def edit
    @user = User.includes(:host_profiles).find(params[:id])
    @host_profile = @user.profile
  end  
  
  def update
    @host_profile = HostProfile.find params[:id]              
    @host_profile.update_attributes(params[:host_profile])
    respond_with(@host_profile, :location => events_path)   
  end
  
  private
  
  def page_layout
    mobile_device? ? 'form' : 'users'
  end 
    
end
