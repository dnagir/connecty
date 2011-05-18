set :domain,          ENV["domain"]
set :application,     domain
set :user,            ENV["user"]
set :destination,     ENV["destination"] || domain
set :web_conf,        ENV["web_conf"]    || ENV["environment"] || 'production'
raise "please set domain=app.domain.name.com" unless domain
raise "please set user=server_username"       unless user

set :port,            ENV["port"] || 9999
set :repository,      "."
set :scm,             :git
set :deploy_via,      :copy   # copy code over to server, no need to configure scm on the server
set :copy_strategy,   :export # only the code
set :copy_remote_dir, "/home/#{user}/apps/#{application}" # otherwise it will copy to /tmp which is bad on a shared host (dir must exist)


set :deploy_to,   "/home/#{user}/apps/#{application}"
set :use_sudo,    false

role :web, destination                          # Your HTTP server, Apache/etc
role :app, destination                          # This may be the same as your `Web` server
role :db,  destination, :primary => true        # This is where Rails migrations will run



after "deploy:update_code", "preconfigure"
desc "Configure the application with correct database and precompile assets"
task :preconfigure, :roles => :app do
  # bundle gems
  run "mkdir -p #{shared_path}/bundle && ln -s #{shared_path}/bundle #{release_path}/vendor/bundle"
  run "cd #{latest_release}; bundle install --deployment --without development test"

  # symlink database.yml: copy if not exists, then link it back (release/config/database.yml -> shared/database.yml)
  run "cp -n #{release_path}/config/database.yml #{shared_path}"
  run "ln -sf #{shared_path}/database.yml #{release_path}/config/database.yml"
  # symlink database file and backup current one
  run "ln -sf #{shared_path}/production.sqlite3 #{release_path}/db/production.sqlite3"
  run "touch #{release_path}/db/production.sqlite3" # make sure at least empty file exists so it can be copied
  run "cp #{release_path}/db/production.sqlite3 #{release_path}/db/production.sqlite3.backup"

  # create the dir for SSL if it doesn't exist
  run "mkdir -p #{shared_path}/ssl/"

  # Compile SCSS
  #run "cd #{latest_release}; bundle exec compass compile #{release_path}"

  # and also prepare nginx.conf  
  config_content = from_template("config/nginx.#{web_conf}.conf.erb")
  put config_content, "#{release_path}/nginx.conf"
end


def get_binding
  binding # So that everything can be used in templates generated for the servers
end

def from_template(file)
  require 'erb'
  template = File.read(File.join(File.dirname(__FILE__), "..", file))
  result = ERB.new(template).result(self.get_binding)
end



namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end


after "deploy", "deploy:cleanup" # leave only 5 releases
