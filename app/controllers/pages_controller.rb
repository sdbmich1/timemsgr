class PagesController < ApplicationController
  layout :user_layout	
  
  def home
  	@title = "Plan, Discover, Track, and Share Activities"
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

  protected  
  
  def user_layout  
    if current_user.nil?  
      "pages"  
    else  
      "application"  
    end  
  end  
end
