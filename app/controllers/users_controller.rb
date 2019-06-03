require 'will_paginate/array'

class UsersController < ApplicationController
  inherit_resources
  include PermalinkResources

  # preload all resource / collection in before filter
  before_filter :collection, :only =>[:index]
  before_filter :resource, :only => [:show, :edit, :update, :destroy]
  before_filter :build_resource, :only => [:new, :create, :index]
  before_filter :sanitize_params, :only => [:update, :create]

  authorize_resource


  def create
    @user = User.new(params[:user])
    @user.ip_address = request.headers["CF-Connecting-IP"] || request.remote_ip

    unless verify_recaptcha
      flash[:error] = "Please solve the captcha."
      @user.errors[:base] << "Captcha was not solved"
    end

    if @user.save
      flash[:notice] = "User successfully created."
      redirect_back_or_default root_path
    else
      render :new
    end
  end


  def delete
    @user = User.find_by_permalink params[:id]
    authorize! :destroy, @user
  end

  def destroy
    @user = User.find_by_permalink params[:id]
    authorize! :destroy, @user

    if params[:commit] == "Cancel"
      flash[:notice] = "Canceled account deletion."
      redirect_to user_path(@user)
      return
    end

    if current_user == @user && !@user.valid_password?(params[:password])
      flash[:error] = "Invalid password."
      redirect_to user_delete_path(@user)
    else
      flash[:notice] = "Successfully deleted account."
      @user.destroy
      redirect_to root_path
    end
  end

  protected

  def sanitize_params
    params[:user].delete :admin unless current_user && current_user.admin
  end

  # Paginate the users collection
  def _collection
    @users ||= end_of_association_chain

    order_collection

    @users.paginate(:per_page => 10, :page => params[:page], :order => 'created_at DESC')
  end

  def order_collection
    order = params[:search] && params[:search][:order]
    order ||= "ascend_by_login"

    order_arr = order.split("_by_")
    direction = order_arr[0]
    column = order_arr[1]

    if direction == "ascend"
      direction = "ASC"
    else
      direction = "DESC"
    end

    if ["created_at", "login"].include? column
      @users = @users.order("#{column} #{direction}")
    elsif "projects_count" == column
      @users = @users.all.sort_by{ |u| u.projects.count }
      @users = @users.reverse if direction == "DESC"
    end
  end
end
