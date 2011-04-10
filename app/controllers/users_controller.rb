class UsersController < ApplicationController
  before_filter :authenticate_user!
  
  def home
  	@user = current_user

	# check for new users
  	if @user.sign_in_count <= 1	
  		redirect_to new_interest_path # welcome_path
  	else
 		redirect_to home_path 
    end 		
  end
  
  def index
  	@user = current_user
  	@title = "Welcome back " + @user.first_name
   	
   end

  def new
  	@user = current_user  
  	@title = "Welcome " + @user.first_name

  end
  
  def show
  end
  
  def update
  	# get current user
 	@user = User.find(current_user)
 	
 	#update database
	if @user.update_attributes params[:user]
       redirect_to home_path(@user), :notice => "User has been saved."
    else
       flash.now[:error] = @user.errors
       respond_to do |format|
          format.html { render :action => :index }
       end
    end
  end
  
  def edit
  	 
  end
  
end
