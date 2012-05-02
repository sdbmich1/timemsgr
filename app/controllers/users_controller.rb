class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_data, :only => [:show, :index]
  layout :user_layout
  respond_to :html, :json, :xml, :js, :mobile
  include SetAssn
  
  def home
    p 'In user controller...'
    redirect_to events_path unless mobile_device?
  end
 
  def edit   
    @area = params[:p]  # determine which profile area to edit
    @user = User.includes(:host_profiles).find(params[:id])
    @picture = set_associations(@user.pictures, 1)  
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
    @subscriptions = @user.subscriptions
  end
  
  private
  
  def user_layout 
    mobile_device? ? (%w(edit new).detect { |x| x == action_name}) ? 'form' : 'list_nosearch' : "users"
  end
  
  def load_data
    @rel_type = params[:rtype]  
  end  
    
end
