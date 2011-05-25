class InterestsController < ApplicationController
  before_filter :authenticate_user!, :load_data	
	respond_to :html, :json, :xml, :js

  def load_data
    
    #set current user
  	@user = current_user  
  	 		
  	# initialize model
  	@interest = Interest.new
 
    # check interest ids
		@selected_ids = @user.interest_ids
	
		# get category data
		@category = Category.includes(:interests)
  end
  
	def new
		
		respond_with(@interest)	
	end
	
	def create
	  # save user interest & channel selections
		set_channels('interest_ids', 'index')
	end
	
	def edit
	  
		# determine which user profile area to edit
    @area = params[:p]

	end
	
	def update
	  
    # save user interest & channel selections
    set_channels('interests', 'index')
		
	end
end
