module ApplicationHelper

  # Return a title on a per-page basis.
  def title
    base_title = "TimeMsgr"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
  def logo
    image_tag("rails.png", :alt => "TimeMsgr", :class => "round")
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
end
