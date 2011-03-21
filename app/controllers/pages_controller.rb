class PagesController < ApplicationController
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

end
