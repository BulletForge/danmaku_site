require 'active_storage_validations/content_type_validator'

module ActiveStorageValidations
  class ContentTypeValidator < ActiveModel::EachValidator # :nodoc:
    # Overwriteing this method to fix rar content type checking.
    def content_type(file)
      file.blob.present? && Marcel::MimeType.for(
        declared_type: file.blob.content_type,
        extension: file.blob.content_type
      )
    end
  end
end
