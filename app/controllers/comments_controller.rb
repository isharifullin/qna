class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: :create
  before_action :load_comment, only: :destroy
  after_action :publish_comment, only: :create

  authorize_resource
  
  respond_to :json, :js  

  def create
    respond_with(@comment = @commentable.comments.create(comment_params.merge(user: current_user)))
  end

  def destroy
    @comment.destroy
  end

  private

  def load_comment
    @comment = Comment.find(params[:id])
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

  def publish_comment
    chanel = "/questions/#{@commentable.try(:question).try(:id) || @commentable.id}/comments"
    PrivatePub.publish_to chanel, comment: render_to_string(template: 'comments/show.json.jbuilder') if @comment.valid?
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end