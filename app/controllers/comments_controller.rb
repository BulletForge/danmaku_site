class CommentsController < ApplicationController
  
  def index
    if params[:user_id]
      @user = User.find_by_permalink params[:user_id]
      if params[:project_id]
        @project = @user.projects.find_by_permalink params[:project_id]
        if params[:version_id]
          @version = @project.versions.find_by_permalink params[:version_id]
          @comments = @version.comments
        else
          @comments = @project.comments
        end
      else
        @comments = @user.comments
      end
    end
  end
  
  def create
    if params[:user_id]
      @user = User.find_by_permalink params[:user_id]
      if params[:project_id]
        @project = @user.projects.find_by_permalink params[:project_id]
        if params[:version_id]
          @version = @project.versions.find_by_permalink params[:version_id]
        end
      end
    end

    @comment = Comment.new(params[:comment])
    if @comment.save
      flash[:notice] = "Comment successfully posted."
    else
      flash[:notice] = "Comment posting failed."
    end
    
    if @version
      redirect_to user_project_version_path(@user, @project, @version)
    elsif @project
      redirect_to user_project_path(@user, @project)
    elsif @user
      redirect_to user_path(@user)
    else
      redirect_to root_path
    end
  end
  
  def destroy
  end
  
end
