class AffiliationsController < ApplicationController
  def new
  	#set current user
  	@user = current_user  
  		
  	# initialize model
    @user.affiliations.build #5.times {}
  end
  
  def edit
    @affiliation = Affiliation.find(params[:id])
  end

  def create
 	#set current user
 	@user = current_user  

	# set new affiliation data
    @affiliation = @user.affiliations.new(params[:affiliation])
    
    if @affiliation.save
      redirect_to user_url, :notice => "Successfully created affiliation."
    else
      render :action => 'new'
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
