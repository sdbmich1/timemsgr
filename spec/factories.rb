# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.first_name            "Joe"
  user.last_name             "Blow" 
  user.email                 "jblow@test.com"
  user.password              "foobar"
  user.city            		 "Detroit"
  user.location_id			     "1"
  user.gender            	 "Male"
  user.birth_date           Time.parse("1967-04-23")
  user.username            "test01"
  user.time_zone           'Eastern Time (US & Canada)'
end

Factory.define :event do |event|
  event.title           "Test title"
  event.start_date      Date.today
  event.start_time      Time.now.strftime("%I:%M%p")
  event.end_date        Date.today
  event.end_time        Time.now.advance(:hours => 2).strftime("%I:%M%p")
  event.address         "123 Elm"
  event.city            "LA"
  event.state           "CA"
  event.postalcode      "90201"
  event.status          "active"
  event.event_type      "ue"
  event.hide            "no"
end

Factory.define :interest do |interest|
  interest.name            "Camping"
  interest.category_id     "119" 
  interest.status          "active"
  interest.hide            "no"
 end

Factory.define :channel do |c|
  c.title           "Test title"
  c.status          "active"
  c.hide            "no"
end

Factory.define :affiliation do |aff|
  aff.name "Foo bar"
  aff.association :user
end

Factory.define :interest_user do |interest|
  interest.name "Foo bar"
  interest.association :user
end

Factory.define :associate do |f|
  f.name "Foo bar"
  f.association :user
end

Factory.define :subscription do |f|
  f.association :user
end

Factory.define :setting do |f|
  f.association :user
end

Factory.define :host_profile do |f|
  f.title "Manager"
  f.association :user
end

Factory.define :channel_location do |f|
  f.association :channel
end