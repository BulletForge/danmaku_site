# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.
require_relative 'config/application'

Rails.application.load_tasks

namespace :assets do
  task migrate_to_active_storage: :environment do
    puts "Migrating Project Assets. Count: #{Project.count}"
    count = 1

    Project.find_each do |project|
      print "[#{count}] Migrating Project ID=#{project.id} ..."
      begin 
        project.migrate_to_active_storage
      rescue => e
        puts "  Error! Message: #{e}"
      end
      puts "  Done!"

      count += 1
    end
  end
end
