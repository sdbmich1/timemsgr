module PagesHelper
  
  def get_image(title)    
      image_tag("#{title.downcase}.png", :alt => get_name_or_logo, :size => "100x100")
  end
end
