class MemberController < ApplicationController
  before_filter :authenticate_user!, :except => [:create]
 
  def new
  	    
  end
  
  def index
  	@title = "Welcome " + current_user.first_name
  	if current_user.save
  		render 'index'
  	else
  		render 'new'
  	end
  end
  
  def destroy
    sign_out :current_user
    redirect_to root_path
  end
end
