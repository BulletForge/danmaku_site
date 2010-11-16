# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def preview_image(project, type)
    if type == :normal
      image = image_tag 'nopreviewnormal.png'
    elsif type == :thumb
      image = image_tag 'nopreviewthumb.png'
    end
    image = image_tag project.images.first.attachment.url(type) unless project.images.empty?
    link_to image, user_project_path(project.user, project)
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
    link_to( options[:as], projects_path(:search => search_params) )
  end
  
  def s3_swf_upload_area(key_prefix)
    raw s3_swf_upload_tag(
      :fileTypes => '*.zip;*.rar;*.7z;*.tar;',
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
      :onUploadComplete => 'uploadingFinishHandler(upload_options,event);'
    )
  end
end