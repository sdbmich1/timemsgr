# RVM bootstrap
#$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "delayed/recipes"
require 'rvm/capistrano'
set :rvm_ruby_string, '1.9.2'
#set :rvm_type, :user

set :application, "koncierge"

# server details
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :deploy_to, "~/sites/#{application}"
set :deploy_via, :remote_cache
set :user, "deploy"
set :use_sudo, false
set :rails_env, "production" 
set :domain, '150.150.2.44'
set :web_domain, "150.150.2.44" 

# repo details
set :scm, :git
set :repository,  "git@github.com:sdbmich1/timemsgr.git"
set :branch, "master"

# roles
role :web, web_domain                      # Your HTTP server, Apache/etc
role :app, domain                          # This may be the same as your `Web` server
role :db,  domain, :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# tasks
namespace :deploy do
  desc "Start Application"
  task :start do
    run "touch #{current_path}/tmp/restart.txt"
  end  
   
  desc "Stop Application"
  task :stop do ; end
  
  desc "Restart Application"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  desc "Symlink shared resources on each release - not used"
  task :symlink_shared, :roles => :app do
    #run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "cp  #{current_path}/config/database.yml #{release_path}/config/database.yml"
  end 
  
  desc "Recreate symlink"
  task :resymlink, :roles => :app do
    run "rm -f #{current_path} && ln -s #{release_path} #{current_path}"
  end
end

before 'deploy:setup', 'rvm:install_rvm'
after 'deploy:update_code', 'deploy:symlink_shared', "deploy:resymlink"
#after "deploy:symlink", "deploy:resymlink", "deploy:update_crontab"

# Delayed Job  
after "deploy:stop",    "delayed_job:stop"  
after "deploy:start",   "delayed_job:start"  
after "deploy:restart", "delayed_job:restart" 
 
