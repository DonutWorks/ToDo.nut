class CommentsController < ApplicationController
  before_action :find_project
  before_action :find_history, except:[ :index]
  def new
    @comment = Comment.new
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    @comment.history = @history

    if @comment.save
      redirect_to project_history_path(@project.user, @project, @history) 
    else 
      render 'new'
    end
  end

  def index
    @comment = Comment.all
  end

  def destroy
    @comment = @history.comments.find(params[:id])
    @comment.destroy

    redirect_to project_history_path(@project.user, @project, @history) 
  end

private
  def comment_params
    params.require(:comment).permit(:contents)
  end

  def find_project
    @project = current_user.find_project(params[:project_title])
  end

  def find_history
    @history = @project.find_history(params[:history_phistory_id])
  end
end
