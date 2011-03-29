class MemberController < ApplicationController
  before_filter :authenticate_user!, :except => [:create]
 
  def new
  	    
  end
  
  def index
  	@member = current_user
  	@title = "Welcome " + @member.first_name
  	
  	# check for new users
  	if @member.sign_in_count <= 1
 # 		@prefs = UserPrefs.new
  		render 'new'
 # 	else
 # 		render 'index'
  	end
  end
  
  def destroy
    sign_out :current_user
    redirect_to root_path
  end
end
