module Votable

  extend ActiveSupport::Concern

  included do
    before_action :load_votable, only: [:upvote, :downvote, :unvote]
  end

  def upvote
    current_user.vote_for(@votable, 1)
    render :vote
  end

  def downvote
    current_user.vote_for(@votable, -1)
    render :vote
  end

  def unvote
    current_user.unvote_for(@votable)
    render :vote
  end

  private

  def model_name
    controller_name.classify.constantize
  end

  def load_votable
    @votable = model_name.find(params[:id])
    instance_variable_set("@#{controller_name.singularize}", @votable)
  end
end