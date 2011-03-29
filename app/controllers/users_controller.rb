class UsersController < ApplicationController

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
  	@user = current_user # User.find(current_user)  
  	@title = "Welcome " + @user.first_name

    # default values 
    #params[:user][:interest_ids] ||= []
    
    # check interest ids
	@selected_ids = @user.interest_ids
	
	#update changes
	@user.update_attributes(params[:user])
 #    	redirect_to friends_path, :notice => "Successfully updated preferences."	
#	end
 
 #  	end 
  end
  
  def show
  end
  
  def update
 #   params[:user][:interest_ids] ||= []
 #   @user.attributes = {'interest_ids' => []}.merge(params[:user] || {})	
 
 	@user = User.find(current_user)
 
	#update database
	if @user.update_attributes params[:user]
       flash[:notice] = "Settings have been saved."
       redirect_to friends_path(@user)
    else
       flash.now[:error] = @user.errors
       respond_to do |format|
          format.html { render :action => :edit}
       end
    end
  end
  
  def edit
  	 render 'index'
  end
  
  def friends

  end    	
end
