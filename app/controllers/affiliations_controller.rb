class AffiliationsController < ApplicationController
  before_filter :authenticate_user!, :load_data	
  layout :page_layout
  respond_to :html, :json, :xml, :js
  
  # add autocomplete on affiliation name 
  autocomplete :organization, :name
    
  def new
  	5.times { @affiliations = @user.affiliations.build } 
  	respond_with(@affiliations)
  end
	
  def edit
    @user = User.find(params[:id])
    respond_with(@affiliations = @user.affiliations)
  end

  def create
    @user = User.find(params[:id])
    @affiliations = @user.affiliations.build(params[:affiliation]) 
    flash[:notice] = "Successfully created affiliation." if @affiliations.save   
    respond_with(@affiliations, :location => home_path)
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "#{get_msg(@user, 'Profile')}" 
      respond_with(@user, :status => :created) do |format|
        format.html { redirect_to home_path }
      end
    else
      respond_with(@user.errors, :status => :unprocessable_entity) do |format|
        @user.sign_in_count <= 1 ? format.html { render :action => :new } : format.html { render :action => :edit }
      end
    end
  end
     
  protected
  
  def page_layout  
    params[:p].blank? ? "application" : "users"  
  end  
  
  def load_data 
    @user = current_user  #set current user
  end

     
end
