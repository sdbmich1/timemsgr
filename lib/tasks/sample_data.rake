require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
 #   Rake::Task['db:reset'].invoke
 #   Rake::Task['db:seed'].invoke
   
   Category.all.each do |f|
      5.times do |n|
        f.interests.create!(:name => "Interests #{n+1}")
      end
    end
   end
 end