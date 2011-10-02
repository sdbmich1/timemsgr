module ApplicationHelper
 
  # returns logo or name
  def get_name_or_logo(*args)
    args[0] ? @name = "koncierge.png" : @name = "Koncierge"
  end
      
  def getcredits
    @credits
  end
  
  def chk_offset(*tm)
    unless @user.blank?
      offset = tm[1] - @user.localGMToffset if tm[1]
      @tm = tm[0].advance(:hours => (0 - offset).to_i) if offset
    end 
    @tm.blank? ? tm[0].strftime("%l:%M %p") : @tm.strftime("%l:%M %p")
  end 
  
  def tsd_event?(etype)
    etlist = EventType.get_tsd_event_types
    (etlist.detect {|x| x.code == etype }).blank?
  end
  
  def is_session?(etype)
    etype == 'es'
  end
  
  def major_event?(etype)
    (%w(conf conv fest conc trmt fr).detect { |x| x == etype}).blank?
  end
  
  def life_event?(etype)
    etlist = EventType.get_life_event_types
    (etlist.detect {|x| x.code == etype }).blank?
  end
  
  def show_date(start_dt)  
    start_dt <= Date.today ? Date.today : start_dt
  end
    
  def get_nice_date(*args) 
    args[0].blank? ? '' : args[1].blank? ? args[0].strftime("%D") : args[0].strftime('%m-%d-%Y') 
  end
  
  def load_meters
    @meters
  end
  
  def get_rating
    case @credits
    when 0..2000
      'POOR'
    when 2000..4000
      'LOW'
    when 4000..6000
      'AVERAGE'
    when 6000..8000
      'GOOD'
    else
      'GREAT'
    end
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
end
