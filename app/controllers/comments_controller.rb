class CommentsController < ApplicationController
  def new
    @comment = Comment.new
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @comment.history_id = params[:history_id]

    if @comment.save
      redirect_to project_history_path(params[:project_id],params[:history_id]) 
    else 
      render 'new'
    end
  end

  def index
    @comment = Comment.all
  end

  def destroy
    @history = History.find(params[:history_id])
    @comment = @history.comments.find(params[:id])
    @comment.destroy

    redirect_to project_history_path(params[:project_id],params[:history_id]) 

  end


private
  def comment_params
    params.require(:comment).permit(:contents)
    
  end
end
