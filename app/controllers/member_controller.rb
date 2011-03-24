class MemberController < ApplicationController
  before_filter :authenticate_user!, :except => [:create]
 
  def new
  	    
  end
  
  def index
  	@user = current_user
  	@title = "Welcome " + @user.first_name
  	
  	# check for new users
  	if @user.sign_in_count <= 1
  		render 'new'
  	else
  		render 'index'
  	end
  end
  
  def destroy
    sign_out :current_user
    redirect_to root_path
  end
end
