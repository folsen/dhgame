set :application, "dhgame"


default_run_options[:pty] = true
set :repository,  "ique@dhgame.eu:/repos/dhgame"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion
set :scm, "git"
set :user, "ique"
set :branch, "master"

set :deploy_to, "/var/www/dhgame"
set :use_sudo, false

role :web, "dhgame.eu"
role :app, "dhgame.eu"
role :db,  "dhgame.eu", :primary => true

namespace :deploy do
  task :restart do
    run "mongrel_cluster_ctl restart --clean"
  end
end