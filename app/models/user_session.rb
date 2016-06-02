class UserSession < Authlogic::Session::Base
  generalize_credentials_error_messages "Invalid username or password."
  validate :suspicious?

  #rails 3 hack
  def to_key
    [id]
  end

  #formtastic hack
  def persisted?
  end

  private

  def suspicious?
    errors.add(:base, "Suspicious email") if attempted_record && attempted_record.suspicious
  end
end