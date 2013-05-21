namespace :data do
  desc "Sync updated_at timestamps for projects and their latest versions"
  task :sync_updated_at => :environment do
    Project.all.each do |project|
      timestamp = [project.updated_at, project.latest_version.updated_at].max
      Project.where(:id => project.id).update_all(:updated_at => timestamp)
      Version.where(:id => project.latest_version.id).update_all(:updated_at => timestamp)
    end
  end
end
