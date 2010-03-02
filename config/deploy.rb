set :application, 'bulletforge'
set :repository,  'git://github.com/Blargel/danmaku_site.git'
set :scm, :git
set :deploy_via, :remote_cache
set :use_sudo, false
set :user, 'deploy'

role :app, 'bulletforge.org'
role :web, 'bulletforge.org'
role :db,  'bulletforge.org', :primary => true

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
set :deploy_to, '/var/www/bulletforge'


after 'deploy:update_code', :roles => :app do
  run <<-BASH
    ln -s #{shared_path}/config/database.yml #{current_release}/config/database.yml &&
    ln -s #{shared_path}/public/system #{current_release}/public/system
    ln -s #{shared_path}/cache #{current_release}/tmp/cache
  BASH
end

namespace :deploy do
  task :default do
    update
    restart
  end

  namespace :web do
    desc "Serve up a custom maintenance page."
    task :disable, :roles => :web do
      require 'erb'

      on_rollback { run "rm #{shared_path}/system/maintenance.html" }
      reason = ENV['REASON']
      deadline = ENV['UNTIL']

      template = File.read("app/views/maintenance/index.html.erb")
      page = ERB.new(template).result(binding)
      put page, "#{shared_path}/system/maintenance.html", :mode => 0644
    end
  end

  task :restart, :roles => :app do
    web.disable
    run "thin restart -C /etc/thin/bulletforge.yml"
    web.enable
  end

  task :start, :roles => :app do
    run "thin start -C /etc/thin/bulletforge.yml"
  end

  task :stop, :roles => :app do
    run "thin stop -C /etc/thin/bulletforge.yml"
  end
end
