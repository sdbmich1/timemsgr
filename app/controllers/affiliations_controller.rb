class AffiliationsController < ApplicationController
  before_filter :authenticate_user!, :load_data	
  layout :page_layout
  
  # add autocomplete on affiliation name 
  autocomplete :organization, :name
  
  def load_data
    
    #set current user
  	@user = current_user  
  end
  
  def new
  		
  	# initialize model
  	5.times do
  	  @user.affiliations.build 
  	end

  end
  
  # lookup affiliation names
  def get_items(parameters)
	   Affiliation.select("DISTINCT(name)").where(['name LIKE ?', "#{parameters[:term]}%"]).limit(10)
  end

 	
  def edit
    @user = User.find(params[:id])
 #   @affiliation = Affiliation.find(params[:id])
  end

  def create

	  # set new affiliation data
    @affiliation = @user.affiliations.build(params[:affiliation])
    
#	  respond_to do |format| 
 #   	if @affiliation.save
 #     		format.html {redirect_to home_path(@user)} #, :notice => "Successfully created affiliation."
 #   	else
 #   		format.html { redirect_to new_affiliation_path(@user) }  
 #   	end		
#	  end
  end

  def update
    @affiliation = Affiliation.find(params[:affiliation])
    
    if @affiliation.update_attributes(params[:affiliation])
      redirect_to user_path, :notice  => "Successfully updated affiliation."
    else
      render :action => 'edit'
    end
  end
  
  def page_layout  
    if !params[:p].blank?  
      "users"  
    else  
      "application"  
    end  
  end
    
end
