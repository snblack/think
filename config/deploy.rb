# config valid for current version and patch releases of Capistrano
lock "~> 3.14.1"

set :application, "think"
set :repo_url, "git@github.com:snblack/think.git"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deployer/think"
set :deploy_user, "deployer"

set :rvm_ruby_version, '2.7.2'

# set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
# set :rbenv_map_bins, %w{rake gem bundle ruby rails}
# set :rbenv_roles, :all # default value

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/master.key"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", 'storage '
