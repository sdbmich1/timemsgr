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
Location.destroy_all

# import sample set of Category
loc_list = "#(file.dirname(__FILE__))/../db/location.yml"

YAML.load_file(loc_list).each_value do |seed|
	loc = Location.create(:city => seed["city"],
						  :state => seed["state"],
						  :country => seed["country"],
						  :time_zone => seed["timezone"] )
	
	puts "Added location #{loc.id}: #{loc.city}"
end 

