# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def preview_image(project, type)
    image = image_tag 'nopreview.png'
    image = image_tag project.images.first.attachment.url(type) unless project.images.empty?
    link_to image, user_project_path(project.user, project)
  end
  
  def swf_upload_area(title, options)
    # get session key
    session_key = RAILS_GEM_VERSION < "2.3.0" ? ActionController::Base.session[0][:session_key] : ActionController::Base.session_options[:key]

    post_params = {}
    post_params['authenticity_token'] = CGI::escape(form_authenticity_token)
    post_params[session_key.to_s] = CGI::escape(cookies[session_key])
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
    </div>}
  end
  
  def w3c_date(date)
     date.utc.strftime("%Y-%m-%dT%H:%M:%S+00:00")
  end  
end