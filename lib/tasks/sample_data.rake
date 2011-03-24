require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    User.create!(:first_name => "Joe",
    			 :last_name => "Test",
                 :email => "jtest@test.com",
                 :password => "setup123",
                 :password_confirmation => "setup123")
    4.times do |n|
      first_name  = Faker::Name.first_name
      last_name  = Faker::Name.last_name
      email = "test-#{n+1}@test.com"
      password  = "password"
      User.create!(:first_name => first_name,
      			   :last_name => last_name,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)
    end
    City.create!(:city => "Detroit", :state => "MI")
    City.create!(:city => "New York", :state => "NY")
    City.create!(:city => "Chicago", :state => "IL")
    City.create!(:city => "San Francisco", :state => "CA")
    City.create!(:city => "Los Angeles", :state => "CA")
   end
end
