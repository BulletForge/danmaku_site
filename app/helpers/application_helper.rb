# Methods added to this helper will be available to all templates in the application.

module ApplicationHelper
  def preview_cover_image_url(cover_image, type = nil)
    return if cover_image.nil?

    case type
    when :cover
      url_for cover_image.variant(resize_to_fill: [1200, 256])
    when :normal
      url_for cover_image.variant(resize_to_fit: [400, 300])
    when :thumb
      url_for cover_image.variant(resize_to_fit: [160, 120])
    else
      url_for cover_image
    end
  end

  def preview_project_image_url(project, type)
    preview_cover_image_url(project.cover_images.first, type) ||
      'nopreviewnormal.png'
  end

  def preview_project_image(project, type, image_options: {}, link_options: {})
    image_url = preview_project_image_url(project, type)
    link_to image_tag(image_url, image_options), user_project_path(project.user, project), link_options
  end

  def w3c_date(date)
    date.utc.strftime('%Y-%m-%dT%H:%M:%S+00:00')
  end

  def has_role?(role)
    return false unless current_user

    current_user.roles.include? role
  end

  def direction(sym)
    search_params = params[:search] || {}
    if search_params[:order] == "descend_by_#{sym}"
      "ascend_by_#{sym}"
    else
      "descend_by_#{sym}"
    end
  end

  def order(_search, options)
    if params[:search]
      search_params = params[:search].dup || {}
      search_params = search_params.permit!.merge(order: direction(options[:by]))
      new_params = { search: search_params }
    else
      new_params = { search: { order: direction(options[:by]) } }
    end

    path = request.env['PATH_INFO'] + '?' + new_params.to_query

    link_to(options[:as], path, options)
  end

  def s3_swf_upload_area(key_prefix)
    raw s3_swf_upload_tag(
      fileTypes: '*.zip;*.rar;*.7z;*.tar;*.dat',
      fileTypeDescs: 'Archive files.',
      keyPrefix: key_prefix,
      selectMultipleFiles: false,
      onQueueChange: 'queueChangeHandler(queue);',
      onUploadingStart: 'uploadingStartHandler();',
      onSignatureIOError: "alert('Signature IO Error');",
      onSignatureXMLError: "alert('Signature XML Error');",
      onSignatureSecurityError: "alert('Signature Security Error');",
      onUploadError: "alert('Upload Error');",
      onUploadIOError: "alert('Upload IO Error');",
      onUploadSecurityError: "alert('Upload Security Error');",
      onUploadProgress: 'progressHandler(progress_event);',
      onUploadComplete: 'uploadingFinishHandler(upload_options,event);',
      buttonUpPath: '/flash/s3_up_button.png',
      buttonOverPath: '/flash/s3_over_button.png',
      buttonDownPath: '/flash/s3_down_button.png',
      buttonWidth: 66,
      buttonHeight: 27
    )
  end

  def tag_list(project)
    tag_list = project.tags.map do |tag|
      link_to h(tag.name), projects_path(search: { tagged_with: tag.name }, search_type: :tags)
    end
    tag_list.join(', ').html_safe
  end

  def no_bot_index?
    @project && @project.unlisted?
  end
end
