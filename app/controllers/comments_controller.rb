class CommentsController < ApplicationController
  before_action :find_project

  def new
    @comment = Comment.new
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @comment.history_id = @project.histories.find_by_phistory_id(params[:history_phistory_id]).id

    if @comment.save
      redirect_to project_history_path(@project.user.nickname, @project.title,params[:history_phistory_id]) 
    else 
      render 'new'
    end
  end

  def index
    @comment = Comment.all
  end

  def destroy
    @history = @project.histories.find_by_phistory_id(params[:history_phistory_id])
    @comment = @history.comments.find(params[:id])
    @comment.destroy

    redirect_to project_history_path(@project.user.nickname, @project.title,params[:history_phistory_id]) 

  end


private
  def comment_params
    params.require(:comment).permit(:contents)
    
  end

  def find_project
    @project = current_user.assigned_projects.find_by_title(params[:project_title])
  end
end
