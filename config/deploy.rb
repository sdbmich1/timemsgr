# RVM bootstrap
#$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "delayed/recipes"
require 'rvm/capistrano'
require 'thinking_sphinx/deploy/capistrano'
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
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end 
  
  desc "Recreate symlink"
  task :resymlink, :roles => :app do
    run "ln -s #{release_path} #{current_path}"
  end
end

namespace :sphinx do
  desc 'create sphinx directory'
  task :create_sphinx_dir, :roles => :app do
    run "mkdir -p #{shared_path}/sphinx"
  end
  
  desc 'create sphinx yaml file in shared folder'
  task :create_yaml, :roles => :app do
    sphinx_yaml = <<-EOF
      development: &base
        bin_path: "/usr/local/bin"
        config_file: "#{shared_path}/config/sphinx.yml"
      production: 
        <<: *base
      test: 
        <<: *base
    EOF
    run "mkdir -p #{shared_path}/config"
    put sphinx_yaml, "#{shared_path}/config/sphinx.yml"  
  end
  
  desc 'Symlink sphinx files and create db directory for indexes'
  task :sphinx_symlink, :roles => :app do
    run "ln -nfs #{shared_path}/sphinx #{release_path}/db/sphinx"
    run "ln -nfs #{shared_path}/config/sphinx.yml #{release_path}/config/sphinx.yml"
    run "ln -nfs #{shared_path}/config/sphinx.conf #{release_path}/config/sphinx.conf"    
  end
   
  desc "Stop the sphinx server"
  task :stop, :roles => [:app], :only => {:sphinx => true} do
    run "cd #{latest_release} && RAILS_ENV=#{rails_env} rake thinking_sphinx:stop"
  end

  desc "Reindex the sphinx server"
  task :index, :roles => [:app], :only => {:sphinx => true} do
    run "cd #{latest_release} && RAILS_ENV=#{rails_env} rake thinking_sphinx:index"
  end

  desc "Configure the sphinx server"
  task :configure, :roles => [:app], :only => {:sphinx => true} do
    run "cd #{latest_release} && RAILS_ENV=#{rails_env} rake thinking_sphinx:configure"
  end

  desc "Start the sphinx server"
  task :start, :roles => [:app], :only => {:sphinx => true} do
    run "cd #{latest_release} && RAILS_ENV=#{rails_env} rake thinking_sphinx:start"
  end

  desc "Rebuild the sphinx server"
  task :rebuild, :roles => [:app], :only => {:sphinx => true} do
    run "cd #{latest_release} && RAILS_ENV=#{rails_env} rake thinking_sphinx:rebuild"
  end  
  
  desc "Activate the sphinx server"
  task :activate_sphinx, :roles => [:app] do
    sphinx_symlink
    configure thinking_sphinx.configure
    thinking_sphinx.start
  end 
end

before 'deploy:setup', 'sphinx:create_db_dir'
before 'deploy:setup', 'sphinx:create_yaml'
#before 'deploy:setup', 'rvm:install_rvm'

# Sphinx
#before 'deploy:update_code', 'sphinx:stop'
after 'deploy:update_code', 'deploy:symlink_shared'#, "deploy:resymlink"
#after "deploy:symlink", "deploy:resymlink", "deploy:update_crontab"
after 'deploy:update_code', "sphinx:sphinx_symlink"
after 'deploy:update_code', "sphinx:configure"
after 'deploy:update_code', "sphinx:rebuild"

# Delayed Job  
after "deploy:stop",    "delayed_job:stop"  
after "deploy:start",   "delayed_job:start"  
after "deploy:restart", "delayed_job:restart" 
 
