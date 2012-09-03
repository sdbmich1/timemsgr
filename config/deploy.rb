# RVM bootstrap
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "delayed/recipes"
require 'rvm/capistrano'
set :rvm_ruby_string, '1.9.2-p290'
set :rvm_type, :user

set :application, "koncierge"

# server details
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :deploy_to, "~/sites/#{application}"
#set :deploy_to, "/var/www/koncierge"
set :deploy_via, :remote_cache
set :user, "deploy"
set :use_sudo, false
set :rails_env, "production" 
set :domain, 'Starfleet5152V1.kitsus.rbca.net'
set :web_domain, "Starfleet5152V2.kitsus.rbca.net" 

# repo details
set :scm, :git
set :repository,  "git@github.com:sdbmich1/timemsgr.git"
set :branch, "master"
#set :scm_username, "sdbmich1"
#set :scm_passphrase, "sdb91mse"
#set :repository,  "~/#{application}/.git"
#set :repository, "git@gitserver:timemsgr.git"
#set :git_enable_submodules, 1

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
  end   
end

after 'deploy:update_code', 'deploy:symlink_shared'

# Delayed Job  
after "deploy:stop",    "delayed_job:stop"  
after "deploy:start",   "delayed_job:start"  
after "deploy:restart", "delayed_job:restart" 
 
