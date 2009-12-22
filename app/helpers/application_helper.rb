# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def download_count(project)
    downloads = 0 
    project.versions.each do |version|
      downloads += version.download_count
    end
    downloads
  end
end
