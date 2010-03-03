class UserSession < Authlogic::Session::Base
  generalize_credentials_error_messages "Invalid username or password."
  
  #rails 3 hack
  def to_key
    [id]
  end
end