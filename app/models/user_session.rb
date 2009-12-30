class UserSession < Authlogic::Session::Base
  before_validation :check_if_blank_with_custom_message
  generalize_credentials_error_messages "Invalid username. Or password. But I'm not telling you which. Hacker."
  
  def check_if_blank_with_custom_message
    errors.add(:base, "I'm pretty sure a blank username or password is not going to work.") if login.blank? || password.blank?
  end
end