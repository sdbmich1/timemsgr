module InterestsHelper
	
  def getlogo(fname)  	
  	image_tag("#{fname.nil? ? 'rails.png' : fname}", :size => "32x32", :class => "int-pic")
  end
   
  def set_fname(fname)  	 
	  fname = "#(file.dirname(__FILE__))/../public/images/" + fname # set file name
  end

end