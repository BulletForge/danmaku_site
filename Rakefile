# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.
require_relative 'config/application'

Rails.application.load_tasks

namespace :assets do
  task migrate_to_active_storage: :environment do
    Project.where(soft_deleted: false).order(downloads: :desc).find_each do |project|
      MigrateProjectsToActiveStorageJob.perform_later project.id
    end
  end
end
