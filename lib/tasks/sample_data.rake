require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
 #   Rake::Task['db:reset'].invoke
 #   Rake::Task['db:seed'].invoke
 
 	# add category data
 #	make_categories
 	
 	# add channels by location
# 	make_channels

    # add organizations  
 #   make_orgs
 
    # add channel locations
    set_channel_locations
  end
end  
 
def make_categories
     Category.all.each do |f|
      5.times do |n|
        f.interests.create!(:name => "Interests #{n+1}")
      end
    end   	
end

def make_channels
	Channel.delete_all
	
	Location.find_each do |f|
	  10.times do |n|
	  	if n < 9 
	  		@x = "active" 
	  	else
	  		@x = "inactive"
	  	end
	  	
        Channel.create!(:name => "#{f.city} #{n+1}", 
        				:title => "#{f.city} - Channel #{n+1}", 
        				:channel_status => @x, :location_id => f.id,
 	      				:start_date => Date.today,
 	      				:start_time => Time.now)
      end
     end
     
     # add channel interests
     make_channel_interests 
end

def set_channel_locations
  
    Location.where('id > 8').each do |f|
      Channel.find_each do |c|
        ChannelLocation.create!(:location_id => f.id, :channel_id => c.id)
      end
    end

end

def make_channel_interests
	 ChannelInterest.delete_all 

	  Interest.find_each do |m|
      	Channel.find_each do |n|
      		ChannelInterest.create!(:interest_id => m.id, :channel_id => n.id)
      	end
      end
end

def make_orgs
  @orgs = Affiliation.select("DISTINCT name, affiliation_type")
  
  @orgs.each do |m|
      Organization.create!(:name => m.name, :org_type => m.affiliation_type)        
  end
end

def add_host_profile
  User.all.each do |u|
    u.host_profile.create()    
  end
end 
    
