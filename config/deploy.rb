set :application, 'bulletforge'
set :repository,  'git://github.com/Blargel/danmaku_site.git'
set :scm, :git
#set :deploy_via, :remote_cache
set :use_sudo, false
set :user, 'deploy'
set :scm_passphrase, "z/pjEeS3]UqFOc3hx1bNo0,p"

role :app, 'ec2-75-101-244-26.compute-1.amazonaws.com'
role :web, 'ec2-75-101-244-26.compute-1.amazonaws.com'
role :db,  'ec2-75-101-244-26.compute-1.amazonaws.com', :primary => true

###########################################
# let you to use local ssh keys
#set :ssh_options, {:forward_agent => true}
#default_run_options[:pty] = true
#on :start do
#    `ssh-add`
#end
###########################################

# production only...
set :branch, 'master'
set :rails_env, 'production'
set :deploy_to, '/home/deploy/projects/bulletforge'


after 'deploy:update_code', :roles => :app do
  run <<-BASH
    rm -f #{current_release}/config/database.yml &&
    rm -rf #{current_release}/public/system &&
    rm -rf #{current_release}/public/cache &&
    ln -s #{shared_path}/config/database.yml #{current_release}/config/database.yml &&
    ln -s #{shared_path}/public/system #{current_release}/public/ &&
    ln -s #{shared_path}/cache #{current_release}/tmp/ &&
    cd #{current_release} && bundle install
  BASH
end

namespace :deploy do

  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :start, :roles => :app do
    #do nothing
  end

  task :stop, :roles => :app do
    #do nothing
  end
end
