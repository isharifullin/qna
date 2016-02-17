class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: :create
  before_action :verify_owner, only: :destroy

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      PrivatePub.publish_to chanel, comment: render_to_string(template: 'comments/show.json.jbuilder')
      render nothing: true
    else
      render json: @comment.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
  end

  private

  def verify_owner
    @comment = Comment.find(params[:id])
    redirect_to root_path  unless current_user.id == @comment.user_id
  end

  def load_commentable
    @commentable = commentable_class.find(params[commentable_id])
  end

  def commentable_class
    params[:commentable].classify.constantize
  end

  def commentable_id
    (params[:commentable].singularize + '_id').to_sym
  end

  def chanel
    "/questions/#{@commentable.try(:question).try(:id) || @commentable.id}/comments"
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end