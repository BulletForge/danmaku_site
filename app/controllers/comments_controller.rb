class CommentsController < ApplicationController
  before_filter :comments, :only => :index
  before_filter :comment, :only =>  :destroy
  before_filter :build_comment, :only => :create
  
  def index
    @comments = comments
  end

  def create
    @comment = build_comment
    if @comment.save
      flash[:notice] = "Comment successfully posted."
    else
      flash[:notice] = "Comment posting failed."
    end
    redirect_back    
  end

  def destroy
    @comment = comment
    @comment.destroy
    redirect_back
  end
  
  private
  
  def comments
    @comments = end_of_association_chain
  end
  
  def build_comment
    @comment = end_of_association_chain.build(params[:comment])
  end
  
  def comment
    @comment = end_of_association_chain.find(params[:id])
  end
  
  def end_of_association_chain
    @end_of_association_chain ||= ( parent.nil? ? Comment : parent.comments )
  end
  
  def parent
    if params[:user_id]
      @user = User.find_by_permalink!(params[:user_id])
      if params[:project_id]
        @project = @user.projects.find_by_permalink!(params[:project_id])
        if params[:version_id]
          @version = @project.versions.find_by_permalink!(params[:version_id])
        end
      end
    end
    @parent ||= (@version || @project || @user)
  end
  
  def redirect_back
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

end
