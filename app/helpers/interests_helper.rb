module InterestsHelper
	
  def logo(fname)
  	if fname.nil?
  		image_tag("rails.png", :alt => "TimeMsgr", :size => "40x40")
	else
 		image_tag(fname, :alt => "TimeMsgr", :size => "40x40")		
  	end
   end
end
