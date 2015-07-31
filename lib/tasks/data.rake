namespace :data do
  desc "Sync updated_at timestamps for projects and their latest versions"
  task :sync_updated_at => :environment do
    Project.all.each do |project|
      timestamp = [project.updated_at, project.latest_version.updated_at].max
      Project.where(:id => project.id).update_all(:updated_at => timestamp)
      Version.where(:id => project.latest_version.id).update_all(:updated_at => timestamp)
    end
  end

  desc "Backfill projects version_number and description columns"
  task :backfill_projects => :environment do
    Project.all.each do |project|
      latest_version = Version.where(:project_id => project.id).max do |v1, v2|
        v1.created_at <=> v2.created_at
      end

      Project.where(:id => project.id).update_all(
        :version_number => latest_version.version_number,
        :description    => latest_version.description
      )
      Asset.where(
        :attachable_type => "Version",
        :attachable_id => latest_version.id
      ).update_all(
        :attachable_type => "Project",
        :attachable_id => project.id
      )
    end
  end
end
