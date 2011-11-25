module ApplicationHelper
 
  # returns logo or name
  def get_name_or_logo(*args)
    args[0] ? @name = "koncierge.png" : @name = "Koncierge"
  end
      
  def getcredits
    @credits
  end
  
  def set_case(val)
    val.capitalize
  end  
  
  def load_meters
    @meters
  end
  
  def get_rating
    case @credits
    when 0..2000;    'POOR'
    when 2000..4000; 'LOW'
    when 4000..6000; 'AVERAGE'
    when 6000..8000; 'GOOD'
    else 'GREAT'
    end
  end
  
  def get_cid(usr)
    usr ? usr.host_profiles[0].subscriptionsourceID : ''
  end  

  # Return a title on a per-page basis.
  def get_title
    base_title = get_name_or_logo
    @title.nil? ? base_title : "#{base_title} | #{@title}"
  end
  
  # returns company logo
  def logo
    image_tag("rails.png", :alt => get_name_or_logo, :class => "round")
  end
  
  # used to toggle breadcrumb images based on current registration step
  def bc_image(bcrumb, val, file1, file2)
    bcrumb >= val ? file1 : file2     
  end
  
  # used to dynamic add fields to a given form
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
  end  
  
  # used to dynamically remove field from a given form
  def link_to_remove_fields(name, f)  
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")  
  end  
  
  #devise settings
  def resource_name
    :user
  end
         
  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end  
end
