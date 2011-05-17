module UsersHelper
  
  def setup_user(person)
    (person).tap do |p|
      p.host_profiles.build if p.host_profiles.empty?
    end
  end
  
  def set_area
    if !@area.nil? 
      case @area
      when "Photo"
        @area = "user_photo"
      when "Prefs"
        @area = "user_prefs"
      when "Contact"
        @area = "user_contact"
      when "Hobbies"
        @area = "user_hobbies"
       when "Affiliations"
        @area = "user_affiliation"
     else
        @area = "user_profile"
      end
    else
      @area = "user_profile"
    end
  end
end
