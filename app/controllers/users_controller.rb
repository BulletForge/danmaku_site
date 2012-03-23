require 'will_paginate/array'

class UsersController < ApplicationController
  inherit_resources
  include PermalinkResources
  
  # preload all resource / collection in before filter
  before_filter :collection, :only =>[:index]
  before_filter :resource, :only => [:show, :edit, :update, :destroy]
  before_filter :build_resource, :only => [:new, :create, :index]
  
  authorize_resource
  

  # Change default flash notice and redirect
  create! do |success, failure|
    success.html {
      #flash "Successfully registered!"
      redirect_back_or_default root_path
    }
  end

  protected
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
      @users.reverse if direction == "ASC"
    end
  end
end
