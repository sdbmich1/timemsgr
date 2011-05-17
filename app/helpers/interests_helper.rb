module InterestsHelper
	
  def getlogo(fname)  	
  	image_tag("#{fname.nil? ? 'rails.png' : fname}", :alt => "TimeMsgr", :size => "32x32")
  end
   
  def set_fname(fname)
   	 # set file name
	   fname = "#(file.dirname(__FILE__))/../public/images/" + fname
  end
end