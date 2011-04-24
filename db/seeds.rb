# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# remove all Category 
#Category.destroy_all

# import sample set of Category
#int_list = "#(file.dirname(__FILE__))/../db/Category.yml"

#YAML.load_file(int_list).each_value do |seed|
#	ints = Category.create(:name => seed["name"])
	
#	puts "Added interest category #{ints.id}: #{ints.name}"
#end 

# remove all locations
#Location.destroy_all

# import sample set of Category
#loc_list = "#(file.dirname(__FILE__))/../db/city.yml"

#YAML.load_file(loc_list).each_value do |seed|
#	loc = Location.create(:city => seed["city"],
#						  :state => seed["state"],
#						  :country => seed["country"],
#						  :time_zone => seed["timezone"] )
	
#	puts "Added location #{loc.id}: #{loc.city}"
#end 


# remove all events
Event.destroy_all

# import sample set of events
ev_list = "#(file.dirname(__FILE__))/../db/event.yml"

YAML.load_file(ev_list).each_value do |seed|
	event = Event.create( :event_name => seed["name"],
					   :title => seed["title"],
  					   :event_type => seed["etype"],
  					   :start_date => seed["startdt"],
 					   :end_date => seed["enddt"],
 					   :start_time => seed["starttime"],
  					   :end_time => seed["endtime"],
  					   :frequency => seed["frequency"],
 					   :cversion => seed["cversion"],
 					   :status => seed["status"],
 					   :hide => seed["hide"],				   
 					   :post_date => seed["postdt"] )
	
	puts "Added event #{event.id}: #{event.title}"
end 

# remove all events
EventPageSection.destroy_all

# import sample set of events
ev_list = "#(file.dirname(__FILE__))/../db/event_page_section.yml"

YAML.load_file(ev_list).each_value do |seed|
  event = EventPageSection.create( :event_type => seed["type"],
             :title => seed["title"],
               :rank => seed["rank"],
               :visible => seed["visible"])
               
  puts "Added event section #{event.id}: #{event.title}"

end
