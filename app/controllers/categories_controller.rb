class CategoriesController < ApplicationController

  def index
    @categories = Category.get_active_list
  end
  
end
