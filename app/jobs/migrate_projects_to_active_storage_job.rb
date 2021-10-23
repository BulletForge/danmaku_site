class MigrateProjectsToActiveStorageJob < ApplicationJob
  queue_as :low

  def perform(project_id)
    project = Project.find(project_id)
    project.migrate_to_active_storage
  end
end
