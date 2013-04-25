# RVM bootstrap
#$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "whenever/capistrano"
require "delayed/recipes"
require 'rvm/capistrano'
require 'thinking_sphinx/deploy/capistrano'
require "bundler/capistrano"
set :rvm_ruby_string, '1.9.2'
set :rvm_type, :system
set :rvm_trust_rvmrcs_flag, 1

set :application, "koncierge"

# server details
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :deploy_to, lambda { capture("echo -n ~/sites/#{application}") }
set :deploy_via, :remote_cache
set :keep_releases, 2
set :user, "deploy"
set :use_sudo, false
set :rails_env, "production" 
set :domain, '150.150.2.44'
set :web_domain, "150.150.2.44" 
set :whenever_command, "bundle exec whenever"
set :whenever_roles, :app 

# repo details
set :scm, :git
set :repository,  "git@github.com:sdbmich1/timemsgr.git"
set :branch, "master"

# roles
role :web, web_domain, '150.150.2.45'                      # Your HTTP server, Apache/etc
role :app, domain, '150.150.2.45'                          # This may be the same as your `Web` server
role :db, '150.150.2.45', :primary => true # This is where Rails migrations will run
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

  desc "Symlink shared resources on each release"
  task :symlink_shared, :roles => :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/api_keys.yml #{release_path}/config/api_keys.yml"    
    run "ln -nfs #{shared_path}/config/memcached.yml #{release_path}/config/memcached.yml"    
  end 
  
  desc "Recreate symlink"
  task :resymlink, :roles => :app do
    puts "\n\n=== Updating the symlink! ===\n\n"
    run "rm -f #{current_path} && ln -s #{release_path} #{current_path}"
  end
end

namespace :sphinx do
  desc 'create sphinx directory'
  task :create_sphinx_dir, :roles => :app do
    run "mkdir -p #{shared_path}/sphinx"
  end
   
  desc 'Symlink sphinx files and create db directory for indexes'
  task :sphinx_symlink, :roles => :app do
#    run "ln -nfs #{shared_path}/sphinx #{release_path}/db/sphinx"
    run "ln -nfs #{shared_path}/config/sphinx.yml #{release_path}/config/sphinx.yml"
    run "ln -nfs #{shared_path}/config/gateway.yml #{release_path}/config/gateway.yml"        
  end
   
  desc "Stop the sphinx server"
  task :stop, :roles => :app do
    unless :previous_release
      run "cd #{previous_release} && RAILS_ENV=#{rails_env} rake thinking_sphinx:stop"
    end
  end

  desc "Reindex the sphinx server"
  task :index, :roles => :app do
    run "cd #{latest_release} && RAILS_ENV=#{rails_env} rake thinking_sphinx:index"
  end

  desc "Configure the sphinx server"
  task :configure, :roles => :app do
    run "cd #{latest_release} && RAILS_ENV=#{rails_env} rake thinking_sphinx:configure"
  end

  desc "Start the sphinx server"
  task :start, :roles => :app do
    run "cd #{latest_release} && RAILS_ENV=#{rails_env} rake thinking_sphinx:start"
  end

  desc "Rebuild the sphinx server"
  task :rebuild, :roles => :app do
    run "cd #{latest_release} && RAILS_ENV=#{rails_env} rake thinking_sphinx:rebuild"
  end    
end

namespace :rvm do
  desc 'Trust rvmrc file'
  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  end
end

namespace :whenever do    
  desc "Update the crontab file for the Whenever Gem."
  task :update_crontab, :roles => :db do
    puts "\n\n=== Updating the Crontab! ===\n\n"
    run "cd #{release_path} && #{whenever_command} --update-crontab #{domain}"
  end    
end

before 'deploy:setup', 'sphinx:create_sphinx_dir' #, 'rvm:install_rvm'

# Sphinx
#before 'deploy:update_code'
after 'deploy:update_code', 'deploy:symlink_shared', 'sphinx:stop', "sphinx:sphinx_symlink", "sphinx:configure", "sphinx:rebuild"
#after "deploy:create_symlink", "deploy:resymlink"
after "deploy", "rvm:trust_rvmrc"

# Delayed Job  
after "deploy:stop",    "delayed_job:stop"  
after "deploy:start",   "delayed_job:start"  
after "deploy:restart", "delayed_job:restart", "deploy:cleanup" 

