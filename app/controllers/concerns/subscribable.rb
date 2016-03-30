module Subscribable

  extend ActiveSupport::Concern

  included do
    before_action :load_question, only: [:subscribe, :unsubscribe]
  end

  def subscribe
    current_user.subscribe(@question)
    render :subscription
  end

  def unsubscribe
    current_user.unsubscribe(@question)
    render :subscription
  end

  private

  def load_subscribable
    @question = Question.find(params[:id])
  end
end