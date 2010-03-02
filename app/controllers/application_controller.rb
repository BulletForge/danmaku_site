# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
 
class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  include Authentication
  include InheritedResources::DSL

  helper :all
  helper_method :current_user_session, :current_user, :set_current_user
  filter_parameter_logging :password, :password_confirmation
  
  before_filter { |c| Authorization.current_user = c.current_user }
  
  protected
  def permission_denied
    flash[:error] = "Sorry, you are not allowed to access that page."
    redirect_to root_url
  end
end