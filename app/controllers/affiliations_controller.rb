class AffiliationsController < ApplicationController
  before_filter :authenticate_user!	
  
  # add autocomplete on affiliation name 
  autocomplete :affiliation, :name
  
  def new
  	#set current user
  	@user = current_user  
  		
  	# initialize model
    @user.affiliations.build 

  end
  
  # lookup affiliation names
  def get_items(parameters)
	Affiliation.group("name").where(['name LIKE ?', "#{parameters[:term]}%"]).limit(10)
  end

 	
  def edit
    @affiliation = Affiliation.find(params[:id])
  end

  def create
 	#set current user
 	@user = current_user  

	# set new affiliation data
    @affiliation = @user.affiliations.build(params[:affiliation])
    
	respond_to do |format| 
    	if @affiliation.save
      		format.html {redirect_to home_path(@user)} #, :notice => "Successfully created affiliation."
    	else
    		format.html { redirect_to new_affiliation_path(@user) }  
#     		render :action => 'new'
    	end		
	end
  end

  def update
    @affiliation = Affiliation.find(params[:affiliation])
    
    if @affiliation.update_attributes(params[:affiliation])
      redirect_to user_path, :notice  => "Successfully updated affiliation."
    else
      render :action => 'edit'
    end
  end
  
end
