module UsersHelper
  
  # build child rows if they don't exist
  def setup_user(person)
    (person).tap do |p|
      p.host_profiles.build if p.host_profiles.empty?
    end
  end
  
  # sets partial name to navigation to corresponding user profile areas
  def set_area
    if !@area.empty? 
      case @area
      when "Photo"
        @area = "user_photo"
      when "Prefs"
        @area = "user_prefs"
      when "Contact"
        @area = "user_contact"
      when "Interests"
        @area = "shared/categories"
      when "Hobbies"
        @area = "user_hobbies"
      when "Affiliations"
        @area = "shared/affiliations"
      else
        @area = "user_profile"
      end
    else
      @area = "user_profile"
    end
  end
end
