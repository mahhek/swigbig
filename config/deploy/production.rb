set :rails_env, "production"
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
    run "export RAILS_ENV=production"
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
    
    #    run "rm -rf #{current_path}/log"
    #    run "rm -rf #{current_path}/config/database.yml"
    #    run "rm -rf #{current_path}/public/system"
    #    run "rm -rf #{current_path}/public/images/photos"
    #    run "rm -rf #{current_path}/public/javascripts/caches"
    #    run "rm -rf #{current_path}/public/stylesheets/caches"
    #    run "rm -rf #{current_path}/public/images/regions"
    #    run "rm -rf #{current_path}/public/images/regions_default"
    #    run "rm -rf #{current_path}/public/images/thumbnails/suggestions"
    #    run "rm -rf #{current_path}/public/facebook_attachment"
    #    run "rm -rf #{current_path}/config/locales"
    #
    #    run "ln -s #{directory_path}/#{stage}/shared/log #{current_path}/log"
    #    run "ln -s #{directory_path}/#{stage}/shared/config/database.yml #{current_path}/config/database.yml"
    #    run "ln -s #{directory_path}/#{stage}/shared/system #{current_path}/public/system"
    #    run "ln -s #{directory_path}/#{stage}/shared/images/photos #{current_path}/public/images/photos"
    #    run "ln -s #{directory_path}/#{stage}/shared/images/regions #{current_path}/public/images/regions"
    #    run "ln -s #{directory_path}/#{stage}/shared/images/regions_default #{current_path}/public/images/regions_default"
    #    run "ln -s #{directory_path}/#{stage}/shared/images/thumbnails/suggestions #{current_path}/public/images/thumbnails/suggestions"
    #    run "ln -s #{directory_path}/#{stage}/shared/images/facebook_attachment #{current_path}/public/facebook_attachment"
    #    run "ln -s #{directory_path}/#{stage}/shared/config/locales #{current_path}/config/locales"
    #    #    run "kill -9 `pidof memcached`"
    #    #    run "memcached -d"
    #    # run "~/reorganizing_permission_files_for_cl1ck1_app"
    #    run "touch #{File.join(current_path,'tmp','restart.txt')}"
    #    run "cd #{current_path} && whenever --update-crontab #{application}_#{stage} --set environment=#{stage}"
    #    #    run "cd #{current_path} && ruby script/job_runner stop #{stage}"
    #    run "cd #{current_path} && ruby script/job_runner restart #{stage}"
  end
end

namespace :bundler do
  task :create_symlink, :roles => :app do
    shared_dir = File.join(shared_path, 'bundle')
    release_dir = File.join(current_release, '.bundle')
    run("mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}")
  end

  task :bundle_new_release, :roles => :app do
    bundler.create_symlink
    run "cd #{release_path} && bundle install --without test"
  end
end

after 'deploy:update_code' do
  run "cd #{release_path}; RAILS_ENV=production rake assets:precompile"
end

after 'deploy:update_code', 'bundler:bundle_new_release'