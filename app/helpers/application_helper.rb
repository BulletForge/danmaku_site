# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def preview_image(project, type)
    image = image_tag 'nopreview.png'
    image = image_tag project.images.first.attachment.url(type) unless project.images.empty?
    link_to image, user_project_path(project.user, project)
  end
end