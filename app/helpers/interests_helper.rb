module InterestsHelper
	
  def logo(fname)
  	if fname.nil?
  		image_tag("rails.png", :alt => "TimeMsgr", :size => "40x40")
	else
 		image_tag(fname, :alt => "TimeMsgr", :size => "40x40")		
  	end
   end
   
   def set_fname(fname)
   	 # set file name
	 fname = "#(file.dirname(__FILE__))/../public/images/" + fname
   end
end
