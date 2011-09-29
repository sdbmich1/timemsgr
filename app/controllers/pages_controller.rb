class PagesController < ApplicationController
  layout :user_layout	
  respond_to :html, :xml, :js, :mobile
  
  def home
  	@title = "Plan, Discover, Schedule and Share Activities"
 	  @menu = BrowseMenu.findmenu('Home') if mobile_device?
  	respond_with(@menu)
  end

  def browse
    @title = "Browse" 
    #@menu = BrowseMenu.findmenu('Browse') if mobile_device?
    @menu = Category.get_active_list
    respond_with(@menu)
  end
  
  def contact
  	@title = "Contact"
  end

  def privacy
  	@title = "Privacy"
  end

  def company
  	@title = "Company"
  end

  def about
  	@title = "About"
  end

  private  
  
  def user_layout 
    mobile_device? || current_user ? "application" : "pages"
  end  
end
