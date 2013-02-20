require 'rvm/capistrano'
#require "bundler/capistrano"



set :location, "54.235.124.43"
set :application, "sample_app"
set :repository,  "git@github.com:vish91/sample_app.git"
set :scm_passphrase,"vishal91shah"
set :domain, location
server domain, :web, :app

set :scm, :git

default_run_options[:pty]= true
set :use_sudo, false


# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :user,"ubuntu"
role :web, location                         # Your HTTP server, Apache/etc
role :app, location                          # This may be the same as your `Web` server
role :db,  location, :primary => true # This is where Rails migrations will run

set :deploy_to, "/home/www/sample_app"
set :ssh_options, {:forward_agent => true }


ssh_options[:keys] = ["/home/akshar/Downloads/sellobuy.pem"]



#set:stages, ["staging","production"]
#set :default_stage, "staging"

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

 set :rake,           "rake"
  set :rails_env,      "development"
  set :migrate_env,    ""
  set :migrate_target, :latest


  
namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end



  desc "reload the database with seed data"
  task :seed do
    run "cd #{current_path}; rake db:data:load  "
  end

  

	
   after "deploy", "deploy:migrate"
   
   
 end
 
 
 namespace :bundle do
  desc "Bundle install"
  task :install, :roles => :app do
    run "cd #{current_path} && bundle install"
  end
 end 
 
