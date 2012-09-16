module PagesHelper
  
  def get_image(title)    
      image_tag("#{title.downcase}.png", :alt => get_name_or_logo, :size => "100x100")
  end
  
  # use current release path for release version number
  def get_version
    str = Dir.pwd.split('/')
    version = str[str.count-1]
  end
end
