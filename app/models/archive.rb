class Archive < Asset
  has_attached_file :attachment  
  MAX_FILE_SIZE = '300 MB'
end
