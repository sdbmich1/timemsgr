class AffiliationsController < ApplicationController
  before_filter :authenticate_user!
  layout :page_layout
  respond_to :html, :json, :xml, :js, :mobile
  include SetAssn
  
  # add auto-complete on affiliation name 
  autocomplete :organization, :OrgName
    
  def new
    @affiliations = set_associations(@user.affiliations, 10)
  end
	
  def edit
    @area = params[:p]  # determine which profile area to edit
    @user = User.find(params[:id])
    @affiliations = set_associations(@user.affiliations, 10)
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
      respond_to do |format|
        format.mobile { redirect_to home_user_path }
        format.html { redirect_to edit_user_path(@user, :p => "Profile") }
      end
    else
      @user.sign_in_count <= 1 ? (render :action => :new) : (render :action => :edit)
    end
  end

  def suggestions
    list = []
    organizations = Organization.search query, :page => params[:page], :per_page => 10
    organizations.each { |org| list << org.OrgName }
    render :text => list 
  end
       
  protected
  
  def page_layout  
    mobile_device? ? 'form' : params[:p].blank? ? "application" : "users"  
  end  
  
  def query
    @query = params[:search]
  end    
  

end
