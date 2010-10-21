ActsAsTaggableOn::TagList.class_eval do
  def extract_and_apply_options_with_downcase!(args)
    extract_and_apply_options_without_downcase!(args)
    args.map!(&:downcase)
  end
  
  alias_method_chain :extract_and_apply_options!, :downcase
end