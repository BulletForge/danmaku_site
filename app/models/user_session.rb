class UserSession < Authlogic::Session::Base
  generalize_credentials_error_messages "Invalid username or password."

end