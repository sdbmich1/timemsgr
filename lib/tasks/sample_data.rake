require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    Rake::Task['db:seed'].invoke
 
 	  # add category data
 	  make_categories
 	
 	  # add channels by location
 	  make_channels

    # add organizations  
    make_orgs
 
    # add channel locations
    set_channel_locations
  end
  
  task :set_host_profiles => :environment do
    build_profiles  
  end
  
  task :set_channels => :environment do
    build_channels
  end
  
  task :set_affiliations => :environment do
    build_affiliations
  end
  
  task :create_notice_types => :environment do
    build_notice_types
  end
  
  task :notice_types => :environment do
    add_notice_type
  end
  
  task :load_latlng => :environment do
    add_lat_lng
  end
  
  task :update_channel_interests => :environment do
    set_channel_interests
  end 
  
  task :add_college_channels => :environment do
    create_college_channels
  end 

  task :set_city_locations => :environment do
    add_city_locations
  end 
end 

def add_lat_lng
  include Schedule
  
  Location.all.each do |loc|
    addr = Schedule::get_offset [loc.city, loc.state].join(', ')
    loc.lat, loc.lng = addr[:lat], addr[:lng] if addr
    loc.save
  end
end 

def set_channel_interests
  ChannelInterest.delete_all 

  # find correct channel based on location
  LocalChannel.all.each do |loc|
    category = Category.select_category(loc.channel_name).flatten 2 
    category.map { |cat| cat.interests.map {|interest| ChannelInterest.find_or_create_by_channel_id_and_interest_id(:channel_id=>loc.id, :interest_id=>interest.id, :category_id=>cat.id)} if cat.interests} if category   
#    category.interests.map {|interest| ChannelInterest.create(:channel_id=>loc.id, :interest_id=>interest.id, :category_id=>category.id)}
  end

end
 
def build_profiles
  User.all.each do |u|
    cid = 'HP0000' + u.id.to_s
    u.host_profiles.create( :ProfileID=>u.id, :HostChannelID => cid, 
      :EntityType => 'G', :ProfileType => 'Social', :subscriptionsourceID => cid,
      :status => 'active', :hide => 'no')
      
  end  
end

def build_channels
  User.all.each do |u|
   cid = 'HP0000' + u.id.to_s
   u.host_profiles.each do |h|
      h.channels.create(:channelID => cid, :subscriptionsourceID => cid,
        :status => 'active', :hide => 'no', :channel_name => "#{u.first_name} #{u.last_name}",
        :channel_title => "#{u.first_name} #{u.last_name}" )
     end
  end
  
end

def build_notice_types
  et = EventType.where('code NOT IN ("log","party")')
  plist = NoticeType.where(:event_type => 'party')
  et.each do |e|
    cnt = 0
    plist.each do |p|
      cnt =+ 1
      NoticeType.find_or_create_by_code_and_event_type(p.code, e.code, :code=>p.code, :event_type=>e.code, 
        :description=>p.description, :sortkey=>cnt)
    end    
  end
end

def add_notice_type
  EventType.all.each do |et|
    NoticeType.create(:code=>'schedule', :event_type=>et.code, :description=>'The following event has been scheduled.',
    :sortkey=>1)
  end
end

def build_affiliations
  Affiliation.all.each do |a|
    org = Organization.find_by_OrgName(a.name)
    unless org.blank?
      a.channelID = org.wschannelID
      a.save
    end
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

def set_presenter_eventid
  EventPresenter.all.each do |p|
    event = Event.find p.event_id
    p.eventid = event.eventid
    p.save
  end
end

def create_college_channels
  # set school environment variables
  school = ENV['SCHOOL_NAME'] || 'San Jose State University'
  city = ENV['CITY_NAME'] || 'San Jose'
  school_size = ENV['SCHOOL_SIZE'] || 'medium'
  promo_code = ENV['PROMO_CODE']
  
  # remove old channels
  ch = LocalChannel.where 'channel_name like ?', '%' + school + '%'
  ch.map {|c| c.destroy}
  
  lc = LocalChannel.get_channel_by_name 'Stanford'  
  lc.each do |channel|  
    # check school size to determine which channels not to create
    if school_size == 'medium'
      ch = ["Lacrosse|Water Polo|Swimming|Football|Men's Volleyball|Golf|Tennis|Gymnastics|Rugby|Circle|Sailing|Rowing|Squash"]
    else
      ch = ['Circle']
    end
    
    if (channel.channel_name =~ /^.*\b(#{ch[0]})\b.*$/i).nil?
      new_channel = LocalChannel.new channel.attributes
      new_channel.channel_name.gsub!('Stanford', school)
      new_channel.channel_title = new_channel.channel_name
      new_channel.localename = city 
      new_channel.cbody.gsub!('Stanford', school) rescue nil
      new_channel.bbody = new_channel.cbody
#      p "Channel: #{new_channel.channel_name}"
    
      # define channel id based on timestamp
      new_channel.channelID = 'PK' + Time.now.to_i.to_s
      p "Channel: #{new_channel.channel_name} #{new_channel.channelID}"
      new_channel.HostProfileID = HostProfile.create_channel_profile new_channel.channel_name, new_channel.channelID, city, promo_code
      new_channel.save
    end
  end
end

def add_city_locations
  include Schedule
  
  ch = LocalChannel.where "channel_name like ?", 'About %'
  ch.each do |channel|
    location = channel.channel_name.split('About ')[1]
    addr = Schedule.get_offset location if location

    if addr    
      cntry = addr[:country] == 'USA'? 'United States' : addr[:country]    
      country = Country.find_by_Description cntry if cntry
      ccode = country.Code if country   
      gmt = GmtTimezone.find_by_code addr[:offset] 
      tzone = gmt.description if gmt
    end
    
    p "#{addr[:city]} | #{addr[:state]} | #{cntry} | #{tzone} | Code #{ccode}" if addr && tzone
    
    # add location
    loc = Location.find_by_city(addr[:city]) if addr # find_or_create_by_city
    if loc && addr && tzone
      loc.state, loc.country_name, loc.time_zone, loc.localGMToffset = addr[:state], cntry, tzone, addr[:offset]
      loc.country_id, loc.status, loc.hide = ccode, 'active', 'no'
      loc.lat, loc.lng = addr[:lat], addr[:lng] 
      loc.save
    end 
  end
end
    
