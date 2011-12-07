class UsersController < ApplicationController
  before_filter :authenticate_user!
  layout :user_layout
  respond_to :html, :json, :xml, :js, :mobile
  include SetAssn
  
  def home
    if @user.sign_in_count <= 1 # check for new users
      redirect_to new_interest_path, :notice => "#{get_msg(@user,'Welcome')}" unless mobile_device?
    else
      redirect_to events_path unless mobile_device?
    end 
  end
 
  def edit   
    @area = params[:p]  # determine which profile area to edit
    @user = User.includes(:host_profiles).find(params[:id])
    @host_profile = @user.host_profiles[0]
    @picture = set_associations(@host_profile.pictures, 1)  
  end
   
  def update       
    @user = User.find(params[:id])                 
    flash[:notice] = "#{get_msg(@user, 'Profile')}" if @user.update_attributes(params[:user])
    respond_with(@user, :location => home_user_path)
  end  
  
  def show
    respond_with(@user = User.find(params[:id]))
  end
  
  def index
    @user = User.find params[:id]
    @rel_type = params[:rtype]
    @subscriptions = @user.subscriptions
  end
  
  private
  
  def user_layout 
    if mobile_device?
      (%w(edit new).detect { |x| x == action_name}) ? 'form' : 'application'
    else
      "users"
    end
  end  
    
end
