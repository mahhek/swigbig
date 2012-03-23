set :rails_env, "staging"
set :user, "root"
set :password, "5Aek6n0iT0"
set :runner, "apache"

set :deploy_to, "#{directory_path}/#{stage}"

# =============================================================================
# ROLES
# =============================================================================
role :web, "68.233.16.141"  # CHANGE THESE LINES TO USE YOUR OCS SERVER NAME
role :app, "68.233.16.141"
role :db,  "68.233.16.141", :primary => true

# =============================================================================
# TASKS
# =============================================================================
namespace :deploy do
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "export RAILS_ENV=staging"
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
    
    #    run "rm -rf #{current_path}/log"
    #    run "rm -rf #{current_path}/config/database.yml"
    #    run "rm -rf #{current_path}/public/system"
    #    run "rm -rf #{current_path}/public/images/photos"
    #    run "rm -rf #{current_path}/tmp/pids"
    #    run "rm -rf #{current_path}/public/images/regions"
    #    run "rm -rf #{current_path}/public/images/regions_default"
    #
    #    run "ln -s #{directory_path}/#{stage}/shared/log #{current_path}/log"
    #    run "ln -s #{directory_path}/shared/config/database.yml #{current_path}/config/database.yml"
    #    run "ln -s #{directory_path}/#{stage}/shared/system #{current_path}/public/system"
    #    run "ln -s #{directory_path}/#{stage}/shared/images/photos #{current_path}/public/images/photos"
    #    run "ln -s #{directory_path}/#{stage}/shared/pids #{current_path}/tmp/pids"
    #    run "ln -s #{directory_path}/#{stage}/shared/images/regions #{current_path}/public/images/regions"
    #    run "ln -s #{directory_path}/#{stage}/shared/images/regions_default #{current_path}/public/images/regions_default"
    #    #run "cd #{current_path} && ./script/runner /script/restart_server.rb staging"
    #    run "cd #{current_path} && kill -9 `cat tmp/pids/server.pid`"
    #    run "cd #{current_path} && /opt/ruby-enterprise-1.8.7-2010.02/bin/ruby script/server -e staging -p 5050 -d"
    #    run "cd #{current_path} && whenever --update-crontab #{application}_#{stage} --set environment=#{stage}"
    #    run "cd #{current_path} && ruby script/job_runner stop #{stage}"
    #    run "cd #{current_path} && ruby script/job_runner start #{stage}"
  end
end

after 'deploy:precompile_assets' do
  run "cd #{release_path}; RAILS_ENV=staging rake assets:precompile"
end
