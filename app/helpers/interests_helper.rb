module InterestsHelper
	
  def logo(fname)
  	if fname.nil?
  		image_tag("rails.png", :alt => "TimeMsgr", :size => "50x50")
	else
 		image_tag(fname, :alt => "TimeMsgr", :size => "50x50")		
  	end
   end
end
