module SwfUploadHelper
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
end
