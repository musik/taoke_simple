set :application, "taoke_simple"
#set :repository,  "git@bitbucket.org:muzik/shop_analyzer.git"
set :repository,  "git@gitcafe.com:muzik/shop_analyzer.git"

set :scm, :git

set :deploy_to, "/home/muzik/shop_analyzer"
role :web, "bzjshl.com"                          # Your HTTP server, Apache/etc
role :app, "bzjshl.com"                          # This may be the same as your `Web` server
role :db,  "bzjshl.com", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"
set :user, "muzik"
set :group, "muzik"
set :sockets_path,File.join(shared_path, "sockets")
set :use_sudo,false
#set :using_rvm,false
ssh_options[:forward_agent] = true

set :branch, "master"
set :rake_bin, 'bundle exec rake'
set :deploy_via, :remote_cache
#set :git_shallow_clone, 1


set :nginx_remote_config,"/etc/nginx/sites-enabled/qjgc.conf"
set :nginx_local_config, "/home/muzik/as3/shop_analyzer/lib/templates/cap/nginx.conf.erb"

set :unicorn_workers,2
set :using_rvm, false

set :environment, 'production'

#Database
after "deploy:setup","db:yml"
after "deploy:finalize_update","db:symlink"
require './lib/cap/db.rb'

#Assets

#Sphinx
#before 'deploy:create_symlink', 'sphinx:pi'
after 'deploy:create_symlink', 'sphinx:symlink'
after 'deploy:create_symlink', 'sphinx:config'
before 'deploy:start','sphinx:start'
#before 'deploy:restart','sphinx:index'
before 'deploy:restart','sphinx:restart'
require './lib/cap/sphinx.rb'

#Unicorn
after "deploy:create_symlink","unicorn:symlink"
after 'deploy:start','unicorn:start'
after 'deploy:restart', 'unicorn:restart' # app IS NOT preloaded
require 'helpers'
require 'recipes/application'
#require 'recipes/unicorn'
require 'capistrano-unicorn'

#Resque
#before 'deploy:restart','resque:restart'
role :resque_worker, "bzjshl.com"
#role :resque_scheduler, "bzjshl.com"
set :workers, { "update_rates_front,update_rates,import_store" => 1 }
require 'capistrano-resque'

require "bundler/capistrano"

after "deploy:restart", "deploy:cleanup"
#set :privates,%w{
  #config/database.yml
#}
#require 'capistrano-helpers/privates'
#set :shared,%w{
  #db/sphinx
#}
#require 'capistrano-helpers/shared'
