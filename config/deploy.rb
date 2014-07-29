default_run_options[:pty] = true

require 'capistrano/ext/multistage'
require 'bundler/capistrano'
#require 'new_relic/recipes'
# require 'rvm/capistrano'

require 'capistrano-unicorn'


set :application, 'myusa-server'
# set :user, ENV['USER'] || :deployer
set :user, "vagrant"
set :web_user, "nobody"
set :web_group, "web"

set :default_stage, 'vagrant'
set :stages, %w(vagrant development staging production)

set :repository, 'git@github.com:18F/myusa-server.git'
# Switch to the following https:// url when publicly available
# set :repository, "https://github.com/18F/myusa-server.git"
set :branch, ENV['BRANCH'] || 'devel'
set :deploy_to, "/var/www/#{application}"
set :deploy_via, :remote_cache
set :copy_exclude, [ '.ruby-gemset' ]
set :ssh_options, { :forward_agent => true }
set :default_shell, '/bin/bash -l'
# set :use_sudo, true
# set :rvm_ruby_string, '2.1.2'
# set :rvm_type, :system
set :keep_releases, 6
set :scm, :git

load 'config/deploy/base'
before 'deploy:assets:precompile','deploy:symlink_configs'

after 'deploy:restart', 'unicorn:reload'    # app IS NOT preloaded
# after 'deploy:restart', 'unicorn:restart'   # app preloaded
# after 'deploy:restart', 'unicorn:duplicate' # before_fork hook implemented (zero downtime deployments)
