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
  
  def setup_project(project)
    returning(project) do |p|
      while(p.images.length < 4) do
        p.images.build
      end
      p.versions.build if p.versions.empty?
    end
  end
  
  def error_messages_for(*params)
    options = params.extract_options!.symbolize_keys
   
    if object = options.delete(:object)
      objects = [object].flatten
    else
      objects = params.collect {|object_name| instance_variable_get("@#{object_name}") }.compact
    end
    
    count  = objects.inject(0) {|sum, object| sum + object.errors.count }
    unless count.zero?
      html = {}
      [:id, :class].each do |key|
        if options.include?(key)
          value = options[key]
          html[key] = value unless value.blank?
        else
          html[key] = 'errorExplanation'
        end
      end
      options[:object_name] ||= params.first

      I18n.with_options :locale => options[:locale], :scope => [:activerecord, :errors, :template] do |locale|
        #header_message = if options.include?(:header_message)
        header_message = "Oops, there's a mistake in here:"
        #  options[:header_message]
        #else
        #  object_name = options[:object_name].to_s.gsub('_', ' ')
        #  object_name = I18n.t(object_name, :default => object_name, :scope => [:activerecord, :models], :count => 1)
        #  locale.t :header, :count => count, :model => object_name
        #end
        #message = options.include?(:message) ? options[:message] : locale.t(:body)
        error_messages = objects.sum {|object| object.errors.collect {|column, error| content_tag(:li, error) } }.join

        contents = ''
        contents << content_tag(options[:header_tag] || :h2, header_message) unless header_message.blank?
        #contents << content_tag(:p, message) unless message.blank?
        contents << content_tag(:ul, error_messages)

        content_tag(:div, contents, html)
      end
    else
      ''
    end
  end  
end