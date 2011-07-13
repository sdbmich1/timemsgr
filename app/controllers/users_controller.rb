require 'rewards'
class UsersController < ApplicationController
  before_filter :authenticate_user!, :load_data
  layout "users"
  respond_to :html, :json, :xml, :js
  include Rewards
   
  def load_data
  	@user = current_user   	
  end
  
  def home
  	if @user.sign_in_count <= 1	# check for new users
      redirect_to new_interest_path, :notice => "#{get_msg(@user,'Welcome')}"
  	else
      redirect_to home_path 
    end 		
  end
  
  def index
  	@title = "Welcome back " + @user.first_name  	
  end

  def new
  end
  
  def show
  end
  
  def edit   
    @user = User.includes(:host_profiles).find(params[:id]) #get user & profile data  
    @area = params[:p]  # determine which profile area to edit
    
    case @area
    when "Interests"
      @category = Category.includes(:interests)
    when "Prefs"     
      @prefs = SessionPref.all  # get session prefs
    end        
  end
   
  def update       
#    set_channels('session_pref_ids', 'edit') if @area == 'Prefs'
    @user = User.find(params[:id])                 
    flash[:notice] = "#{get_msg(@user, 'Profile')}" if @user.update_attributes(params[:user])
    respond_with(@user, :location => home_path)
  end  
    
end
