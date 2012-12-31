set :application, "taoke_simple"
#set :repository,  "git@bitbucket.org:muzik/shop_analyzer.git"
set :repository,  "git@gitcafe.com:muzik/taoke_simple.git"

set :scm, :git

set :deploy_to, "/home/muzik/taoke_simple"
role :web, "rhhost"                          # Your HTTP server, Apache/etc
role :app, "rhhost"                          # This may be the same as your `Web` server
role :db,  "rhhost", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"
set :user, "muzik"
set :group, "muzik"
set :sockets_path,File.join(shared_path, "sockets")
set :use_sudo,false
set :using_rvm,false
ssh_options[:forward_agent] = true

set :branch, "master"
set :rake_bin, 'bundle exec rake'
set :deploy_via, :remote_cache
#set :git_shallow_clone, 1

set :default_environment, {
    'PATH' => "$HOME/.rvm/gems/ruby-1.9.3-p327/bin:$HOME/.rvm/gems/ruby-1.9.3-p327@global/bin:$HOME/.rvm/rubies/ruby-1.9.3-p327/bin:$HOME/.rvm/bin:$PATH",
    'GEM_HOME' => '/home/muzik/.rvm/gems/ruby-1.9.3-p327:/home/muzik/.rvm/gems/ruby-1.9.3-p327@global'
}
#recipes
require 'helpers'
require 'recipes/application'
#require './lib/recipes/hooks.rb'
#after "deploy:finalize_update","bundler:install"
#require './lib/recipes/bundler.rb'

#RVM
#set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"")
#set :rvm_install_ruby_params, '--1.9'      # for jruby/rbx default to 1.9 mode
#set :rvm_install_pkgs, %w[libyaml openssl] # package list from https://rvm.io/packages
#set :rvm_install_ruby_params, '--with-opt-dir=/usr/local/rvm/usr' # package support

#before 'deploy:setup', 'rvm:install_rvm'   # install RVM
#before 'deploy:setup', 'rvm:install_pkgs'  # install RVM packages before Ruby
#before 'deploy:setup', 'rvm:install_ruby'  # install Ruby and create gemset, or:
#before 'deploy:setup', 'rvm:create_gemset' # only create gemset
#before 'deploy:setup', 'rvm:import_gemset' # import gemset from file

#require "rvm/capistrano"

#NGinx
set :nginx_remote_config,"/etc/nginx/sites-enabled/sqfy.conf"
set :nginx_local_config, "./lib/templates/nginx.conf.erb"
set :application_uses_ssl, false

require 'recipes/nginx'


set :environment, 'production'

#Database And config files
#before "deploy:assets:precompile","app:"
require './lib/recipes/db.rb'
after "deploy:finalize_update","app:yml"
after "deploy:finalize_update","app:symlink"
require './lib/recipes/custom.rb'

#set :normal_symlinks, %w(tmp log config/database.yml config/application.yml)
#after "deploy:create_symlink","symlinks:make"
#require 'recipes/symlinks'

#Assets

#Sphinx
#before 'deploy:create_symlink', 'sphinx:pi'
after 'deploy:create_symlink', 'sphinx:symlink'
#after 'deploy:create_symlink', 'sphinx:config'
before 'deploy:start','sphinx:start'
#before 'deploy:restart','sphinx:index'
before 'deploy:restart','sphinx:restart'
require './lib/recipes/sphinx.rb'

#Unicorn
set :unicorn_workers,2
require './lib/recipes/unicorn.rb'

after "deploy:create_symlink","unicorn:symlink"
after 'deploy:start','unicorn:start'
after 'deploy:restart', 'unicorn:restart' # app IS NOT preloaded
#require 'recipes/unicorn'
require 'capistrano-unicorn'

#Resque
#before 'deploy:restart','resque:restart'
#role :resque_worker, "rhhost"
##role :resque_scheduler, "bzjshl.com"
#set :workers, { "update_rates_front,update_rates,import_store" => 1 }
#require 'capistrano-resque'

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
