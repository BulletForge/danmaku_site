# Methods added to this helper will be available to all templates in the application.

module ApplicationHelper
  def preview_image(project, type)
    if type == :normal
      image = image_tag 'nopreviewnormal.png'
    elsif type == :thumb
      image = image_tag 'nopreviewthumb.png'
    end
    image = image_tag project.images.first.attachment.url(type) unless project.images.empty?
    link_to image, user_project_path(project.user, project), :class => "thumbnail"
  end
  
  def w3c_date(date)
     date.utc.strftime("%Y-%m-%dT%H:%M:%S+00:00")
  end
  
  def setup_project(project)
    returning(project) do |p|
      while(p.images.length < 4) do
        p.images.build
      end
      p.versions.build if p.versions.empty?
    end
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
  
  def order(search, options)
    search_params = params[:search] || {}
    search_params = search_params.merge( :order => direction(options[:by]) )

    case options[:path]
    when "projects"
      path = projects_path(:search => search_params)
    when "users"
      path = users_path(:search => search_params)
    else
      path = root_path
    end

    link_to( options[:as], path, options )
  end
  
  def s3_swf_upload_area(key_prefix)
    raw s3_swf_upload_tag(
      :fileTypes => '*.zip;*.rar;*.7z;*.tar;*.dat',
      :fileTypeDescs => 'Archive files.',
      :keyPrefix => key_prefix,
      :selectMultipleFiles => false, 
      :onQueueChange => 'queueChangeHandler(queue);', 
      :onUploadingStart => 'uploadingStartHandler();', 
      :onSignatureIOError => "alert('Signature IO Error');", 
      :onSignatureXMLError => "alert('Signature XML Error');", 
      :onSignatureSecurityError => "alert('Signature Security Error');", 
      :onUploadError => "alert('Upload Error');", 
      :onUploadIOError => "alert('Upload IO Error');", 
      :onUploadSecurityError => "alert('Upload Security Error');", 
      :onUploadProgress => 'progressHandler(progress_event);', 
      :onUploadComplete => 'uploadingFinishHandler(upload_options,event);',
      :buttonUpPath => '/flash/s3_up_button.png',
      :buttonOverPath => '/flash/s3_over_button.png',
      :buttonDownPath => '/flash/s3_down_button.png',
      :buttonWidth => 66,
      :buttonHeight => 27
    )
  end

  def tag_list(project)
    puts project
    tag_list = project.tags.map do |tag| 
      link_to h(tag.name), projects_path(:search => {:tagged_with => tag.name}, :search_type => :tags)
    end
    tag_list.join(", ").html_safe
  end
end