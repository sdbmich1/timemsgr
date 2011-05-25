class UsersController < ApplicationController
  before_filter :authenticate_user!, :load_data
  layout "users"
  
  # add autocomplete on affiliation name 
  autocomplete :organization, :name
  
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
    
#    debugger
    
    #get user & profile data
    @user = User.includes(:host_profiles).find(params[:id])
          
    # determine which profile area to edit
    @area = params[:p]
    
    case @area
    when "Interests"
      get_interests
    when "Prefs"
      # get session prefs
      @prefs = SessionPref.all
  
    else
    end
         
  end
   
  def update
       
    # save user interest & channel selections
    case @area
    when 'Prefs'
      set_channels('session_pref_ids', 'edit')
    when 'Interests'
      set_channels('interest_ids', 'edit')
    else
      set_channels('other', 'index')
    end
  end   
  
  protected
  
  # get category & interest data
  def get_interests     
     @category = Category.includes(:interests)
  end
end
