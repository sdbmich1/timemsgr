class InterestsController < ApplicationController
  before_filter :authenticate_user!	
	respond_to :html, :json, :xml, :js

	def new
		#set current user
  	@user = current_user  
  	 		
  	# initialize model
  	@interest = Interest.new
 
    # check interest ids
		@selected_ids = @user.interest_ids
	
		# get category data
		@category = Category.includes(:interests)	
		
		respond_with(@interest)	
	end
	
	def create
	  # save user interest & channel selections
		set_channels('interest_ids')
	end
	
	def edit
		
	end
	
	def update
		
	end
end
