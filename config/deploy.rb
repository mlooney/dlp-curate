# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "dlp-curate"
set :repo_url, "https://github.com/emory-libraries/dlp-curate.git" 
set :deploy_to, '/opt/dlp-curate'
set :rails_env, 'production'
set :default_env, 'PASSENGER_INSTANCE_REGISTRY_DIR' => '/var/run'
set :assets_prefix, "#{shared_path}/public/assets"

SSHKit.config.command_map[:rake] = 'bundle exec rake'
#SSHKit.config.command_map[:sidekiq] = "bundle exec /opt/rh/rh-ruby25/root/usr/bin/sidekiq"
#set :sidekiq, "bundle exec /opt/rh/rh-ruby25/root/usr/bin/sidekiq"
set :branch, ENV['REVISION'] || ENV['BRANCH'] || ENV['BRANCH_NAME'] || 'master'

append :linked_dirs, "log"
append :linked_dirs, "public/assets"
append :linked_dirs, "tmp/pids"
append :linked_dirs, "tmp/cache"
append :linked_dirs, "tmp/sockets"

append :linked_files, ".env.production"
append :linked_files, "config/secrets.yml"

#Rake::Task["sidekiq:stop"].clear_actions
#Rake::Task["sidekiq:start"].clear_actions
#Rake::Task["sidekiq:restart"].clear_actions
#namespace :sidekiq do
#  task :stop do
#    on roles(:app) do
#      execute :sudo, :systemctl, :stop, :sidekiq
#    end
#  end
#  task :start do
#    on roles(:app) do
#      execute :sudo, :systemctl, :start, :sidekiq
#    end
#  end
#  task :restart do
#    on roles(:app) do
#      execute :sudo, :systemctl, :restart, :sidekiq
#    end
#  end
#end

namespace :deploy do
  after :finishing, :restart_apache do
    on roles(:app) do
      execute :sudo, :systemctl, :restart, :httpd
    end
  end
end

namespace :deploy do
  Rake::Task["migrate"].clear_actions
  task :migrate do
    puts "no migration"
  end
end
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure