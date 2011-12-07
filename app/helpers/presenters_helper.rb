module PresentersHelper 
  
  def any_details?(model)
    %w(work_phone work_email twitter_name facebook_name linkedin_name skype_name website).each {
         |method| return true unless model.send(method).blank?
       }
    false
  end  
end
