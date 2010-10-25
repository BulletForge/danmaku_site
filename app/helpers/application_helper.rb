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
  
  def swf_upload_area(title, options)
    # get session key
    session_key = Rails.application.config.session_options[:key]

    post_params = options.delete(:post_params) || {}     
    post_params['authenticity_token'] = CGI::escape(form_authenticity_token)
    post_params[session_key.to_s] = CGI::escape(cookies[session_key])
    post_params = post_params
    options = options.reverse_merge({'post_params' => post_params})
    
    %Q{<div class="swfUploadArea">
        <script type="application/json">
          #{options.to_json}
        </script>
        <div class="embedArea">
            <div class="embedButton">
              <input type="button" value="#{title}" />
              <div class="placeHolder" id="swfUploadButton"></div>
            </div>
        </div>
        <ul class="uploadContainer">
        </ul>
    </div>}.html_safe
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
end