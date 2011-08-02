class AffiliationsController < ApplicationController
  before_filter :authenticate_user!, :load_data	
  layout :page_layout
  respond_to :html, :json, :xml, :js
  
  # add autocomplete on affiliation name 
  autocomplete :organization, :name
  
  def load_data 
  	@user = current_user  #set current user
  	@credits = UserCredit.where('user_id = ?',@user.id).sum(:credits)
  end
  
  def new
  	5.times do 
  	  @affiliations = @user.affiliations.build 
  	end
  	respond_with(@affiliations)
  end
	
  def edit
    @user = User.find(params[:id])
    @affiliations = @user.affiliations
    respond_with(@affiliations)
  end

  def create
    @user = User.find(params[:id])
    @affiliation = @user.affiliations.build(params[:affiliation]) 
    debugger
    flash[:notice] = "Successfully created affiliation." if @affiliation.save   
    respond_with(@affiliation, :location => home_path)
  end

  def update
    @user = User.find(params[:id])
    @affiliation = @user.affiliations   
    flash[:notice] = "Successfully updated affiliation." if @affiliation.save
    respond_with(@user, :location => user_path)
  end
  
  def destroy
  end
   
  protected
  
  def page_layout  
    params[:p].blank? ? "application" : "users"  
  end  
  
  # lookup affiliation names
  def get_items(parameters)
     Affiliation.select("DISTINCT(name)").where(['name LIKE ?', "#{parameters[:term]}%"]).limit(10)
  end
    
end
