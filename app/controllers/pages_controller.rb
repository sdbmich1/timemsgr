class PagesController < ApplicationController
  layout :user_layout	
  respond_to :html, :xml, :js, :mobile
  
  def home
  	@title = "Plan, Discover, Track, and Share Activities"
  	respond_with(@title)
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
