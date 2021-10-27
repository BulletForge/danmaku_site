class UserSessionsController < ApplicationController
  respond_to :html
  inherit_resources
  actions :new, :create, :destroy

  # preload all resource / collection in before filter
  before_action :collection, only: [:index]
  before_action :resource, only: %i[show edit update destroy]
  before_action :build_resource, only: %i[new create index]

  authorize_resource

  create! do |success, failure|
    success.html do
      user = UserSession.find.record
      user.ip_address = current_ip_address
      user.save
      flash[:notice] = 'Successfully logged in!'
      redirect_back_or_default root_path
    end
    failure.html do
      render action: :new
    end
  end

  destroy! do |format|
    format.html do
      flash[:notice] = 'Successfully logged out!'
      redirect_back_or_default root_path
    end
  end

  protected

  def resource
    current_user_session
  end

  def build_resource
    @user_session = UserSession.new(user_session_params.to_h)
  end

  def user_session_params
    params.fetch(:user_session, {}).permit(:login, :password, :remember_me)
  end
end
