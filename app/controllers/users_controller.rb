class UsersController < ApplicationController
  before_filter :authenticate_user!, :load_data
  layout :user_layout
  respond_to :html, :json, :xml, :js, :mobile
     
  def home
  	if @user.sign_in_count <= 1	# check for new users
      redirect_to new_interest_path, :notice => "#{get_msg(@user,'Welcome')}"
  	else
      redirect_to home_path unless mobile_device?
    end 
  end
  
  def edit   
    @area = params[:p]  # determine which profile area to edit
    respond_with(@user = User.includes(:host_profiles).find(params[:id]))       
  end
   
  def update       
    @user = User.find(params[:id])                 
    flash[:notice] = "#{get_msg(@user, 'Profile')}" if @user.update_attributes(params[:user])
    respond_with(@user, :location => home_path)
  end  
  
  def show
    respond_with(@user = current_user)
  end
  
  def index
    redirect_to home_user_path
  end
  
  private
  
  def user_layout 
    mobile_device? ? "application" : "users"
  end  
  
  def load_data
    @user = current_user    
  end
    
end
