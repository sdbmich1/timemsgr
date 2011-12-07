module UsersHelper
  
  # build child rows if they don't exist
  def setup_user(person)
    (person).tap do |p|
      p.host_profiles.build if p.host_profiles.empty?
    end
  end
  
  # sets partial name to navigation to corresponding user profile areas
  def set_area
    case @area
    when "Prefs"; @area = "user_prefs"
    when "Contact"; @area = "user_contact"
    when "Hobbies"; @area = "user_hobbies"
    else @area = "user_profile"
    end
  end
  
  def user_exists?(ulist, usr)
    ulist.detect{|x| same_user?(x, usr)}
  end
  
  def same_user?(usr1, usr2)
    usr1.id == usr2.id
  end
  
  def get_status(trkd_id, trkr_id)
    Relationship.get_status(trkd_id, trkr_id)
  end
  
  def get_rel_type(trkd_id, trkr_id)
    Relationship.get_rel_type(trkd_id, trkr_id)
  end
  
end
