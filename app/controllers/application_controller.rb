# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
 
class ApplicationController < ActionController::Base
  #include ExceptionNotifiable
  include Authentication
  include InheritedResources::DSL

  helper :all
  helper_method :current_user_session, :current_user, :set_current_user
  
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end
end