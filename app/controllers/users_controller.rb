class UsersController < ApplicationController
  before_filter :authenticate_user!

  def home
  	@user = current_user

	# check for new users
  	if @user.sign_in_count <= 1	
  		redirect_to welcome_path
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

    # check interest ids
	@selected_ids = @user.interest_ids
	
	# get category data
	@category = Category.includes(:interests)
  end
  
  def show
  end
  
  def update
  	# get current user
 	@user = User.find(current_user)
 	
 	# reset if no selections are made
	#   params[:user][:interest_ids] ||= []
    @user.attributes = {'interest_ids' => []}.merge(params[:user] || {})	
 
	#update database
	if @user.update_attributes params[:user]
       redirect_to new_subscription_path(@user), :notice => "Interests have been saved."
    else
       flash.now[:error] = @user.errors
       respond_to do |format|
          format.html { render :action => :index }
       end
    end
  end
  
  def edit
  	 
  end
  
  def select_friends

  end 
end
