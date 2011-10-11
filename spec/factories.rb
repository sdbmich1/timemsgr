# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.first_name            "Joe"
  user.last_name             "Blow" 
  user.email                 "jblow@test.com"
  user.password              "foobar"
  user.location_id	     1
  user.localGMToffset	     -8.0
  user.gender          	 "Male"
  user.birth_date           Time.parse("1967-04-23")
  user.username            "test01"
  user.time_zone           'Eastern Time (US & Canada)'
end

Factory.define :event do |event|
  event.event_title           "Test title"
  event.event_name           "Test title"
  event.eventstartdate      Date.today+2.days
  event.eventstarttime      Time.now
  event.eventenddate        Date.today+3.days
  event.eventendtime        Time.now.advance(:hours => 2)
  event.mapstreet          "123 Elm"
  event.mapcity            "LA"
  event.mapstate           "CA"
  event.mapzip             "90201"
  event.status              "active"
  event.event_type          "ue"
  event.hide                "no"
  event.localGMToffset      -8.0
  event.endGMToffset        -8.0
  event.contentsourceID     "123"
  event.session_type         ""
end  

Factory.define :private_event do |event|
  event.event_title           "Test title"
  event.event_name           "Test title"
  event.eventstartdate      Date.today+2.days
  event.eventstarttime      Time.now
  event.eventenddate        Date.today+3.days
  event.eventendtime        Time.now.advance(:hours => 2)
  event.mapstreet          "123 Elm"
  event.mapcity            "LA"
  event.mapstate           "CA"
  event.mapzip             "90201"
  event.status              "active"
  event.event_type          "ue"
  event.hide                "no"
  event.localGMToffset      -8.0
  event.endGMToffset        -8.0
  event.contentsourceID     "123"
end  

Factory.define :life_event do |event|
  event.event_title           "Test title"
  event.event_name           "Test title"
  event.eventstartdate      Date.today+2.days
  event.eventstarttime      Time.now
  event.eventenddate        Date.today+3.days
  event.eventendtime        Time.now.advance(:hours => 2)
  event.mapstreet          "123 Elm"
  event.mapcity            "LA"
  event.mapstate           "CA"
  event.mapzip             "90201"
  event.status              "active"
  event.event_type          "ue"
  event.hide                "no"
  event.localGMToffset      -8.0
  event.endGMToffset        -8.0
  event.contentsourceID     "123"
end  

Factory.sequence :event_name do |n|
  "Event-#{n}"
end
   
Factory.sequence :channel_name do |n|
  "Channel-#{n}"
end
   
Factory.sequence :channelID do |n|
  "Channel-#{n}"
end
   
Factory.define :host_profile do |hp|
  hp.HostName             "Blow"
  hp.status          "active"
  hp.hide            "no"
  hp.ProfileID           1
  hp.HostChannelID           "T00001"
  hp.subscriptionsourceID           "T00001"
end

Factory.define :presenter do |presenter|
  presenter.name             "Blow"
  presenter.title             "Manager"
  presenter.org_name              "foobar"
  presenter.bio                          "Detroit"
end
   
Factory.define :channel do |c|
  c.channelID           "T00001"
  c.channel_title           "Test title"
  c.channel_name           "Test title"
  c.status          "active"
  c.hide            "no"
  c.subscriptionsourceID           "T00001"
  c.association :host_profile
end

Factory.define :cat_interest do |interest|
  interest.name            "Camping"
  interest.category_id     "119" 
  interest.status          "active"
  interest.hide            "no"
 end

Factory.define :affiliation do |aff|
  aff.name "Foo bar"
  aff.association :user
end

Factory.define :event_track do |e|
  e.name "Foo bar"
  e.association :event
end

Factory.define :country do |country|
  country.sequence(:Code) {|n| "Country #{n}" }
end

Factory.define :location do |location|
  location.sequence(:city) {|n| "City #{n}" }
  location.association :country
end

Factory.define :associate do |f|
  f.name "Foo bar"
  f.association :user
end

Factory.define :country_with_locations, :parent => :country do |country|
  country.after_create { |t| 25.times { Factory.build(:location, :country => t)
} }
end
   
Factory.define :contact_detail do |e|
  e.work_email "test@gmail.com"
  e.association :presenter
end
   
Factory.define :presenter_with_details, :parent => :presenter do |presenter|
  presenter.after_create { |a| Factory(:contact_detail, :presenter => a) }
end

Factory.define :event_site do |e|
  e.name "Foo bar"
  e.association :event
end
   
Factory.define :picture do |e|
  e.photo_file_name           "/spec/fixtures/photo.jpg" # File.new File.join(Rails.root, "/spec/fixtures", "photo1.jpg")
  e.photo_content_type        'image/jpeg'
  e.photo_file_size           1.megabytes
  e.photo_updated_at          Time.now
  e.association :event
end

Factory.define :subscription do |f|
  f.channelID           "T00001"
  f.contentsourceID           "T00001"
end

Factory.define :category do |category|
  category.name "Foo bar"
end
   
Factory.define :interest do |interest|
  interest.name "Foo bar"
  interest.association :category
end
   
Factory.define :channel_interest do |interest|
  interest.association :channel
  interest.association :interest
end
   
Factory.define :channel_location do |location|
  location.association :channel
  location.association :location
end
   
Factory.define :event_presenter do |f|
  f.event_id     1
  f.presenter_id 1
  f.association :event
end
   
Factory.define :session_relationship do |f|
  f.event_id     1
  f.session_id 1
  f.association :event
end   

Factory.define :esession do |f|
  f.association :event
end
