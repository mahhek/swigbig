abort "needs capistrano 2" unless respond_to?(:namespace)

set :stages, %w(staging production)
set :default_stage, "staging"
require 'capistrano/ext/multistage'
require "bundler/capistrano"

# =============================================================================
# REQUIRED VARIABLES
# =============================================================================
set :application, "SwigBIG"  # CHANGE THIS LINE TO USE YOUR WEBSITE'S NAME
set :repository,  "ssh://git@repositories.41studio.com/41studio/swigbig.git"  # CHANGE THIS LINE TO USE YOUR SCM REPO

set :directory_path, "/opt/rails_apps/#{application}"

# =============================================================================
# OPTIONAL VARIABLES
# =============================================================================
set :scm, :git
#set :scm_username, "arul"
#set :scm_passphrase,  Proc.new { Capistrano::CLI.password_prompt('Git Password: ') }

set :use_sudo, false
set :branch, "master"
set :deploy_via, :checkout
set :git_shallow_clone, 1
# set :scm_verbose, true

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
