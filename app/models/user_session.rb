class UserSession < Authlogic::Session::Base
  generalize_credentials_error_messages "Invalid username. Or password. But I'm not telling you which. Hacker."

end