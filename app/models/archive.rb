class Archive < Asset
  has_attached_file :attachment  
  MAX_FILE_SIZE = '300 MB'

  def attachment_with_fast_upload=(file_params)
    if file_params && file_params.respond_to?('[]')
      tmp_upload_dir = "#{file_params['path']}_1"
      tmp_file_path = File.join(tmp_upload_dir, file_params['name'])
      FileUtils.mkdir_p(tmp_upload_dir)
      FileUtils.mv(file_params['path'], tmp_file_path)
      self.attachment_without_fast_upload = File.new(tmp_file_path)
    end
  end
  
  alias_method_chain :attachment=, :fast_upload
end
