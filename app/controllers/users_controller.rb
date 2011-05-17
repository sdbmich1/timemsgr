class UsersController < ApplicationController
  before_filter :authenticate_user!, :load_data
  layout "users"
  
  def load_data
  	@user = current_user   	
  end
  
  def home
 
	# check for new users
  	if @user.sign_in_count <= 1	
      redirect_to new_interest_path # welcome_path
  	else
      redirect_to home_path 
    end 		
  end
  
  def index
  	@title = "Welcome back " + @user.first_name
   	
   end

  def new
   	@title = "Welcome " + @user.first_name

  end
  
  def show
  end
  
  def edit
    
    debugger
    
    #get user & profile data
    @user = User.includes(:host_profiles).find(params[:id])
          
    # determine which profile area to edit
    @area = params[:p]
    
    # get session prefs
    @prefs = SessionPref.all
       
    # check channel ids
    @selected_ids = @user.session_pref_ids
      
  end
   
  def update
       
    # save user interest & channel selections
    set_channels('session_pref_ids', 'edit')
  end   
end
