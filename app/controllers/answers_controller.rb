class AnswersController < ApplicationController
  include Votable

  before_action :authenticate_user!
  before_action :load_question, only: [:new, :create]
	before_action :load_answer, only: [:update, :destroy, :make_best]
  before_action :verify_owner, only: [:update, :destroy]
  before_action :verify_question_owner, only: [:make_best]
  after_action :publish_answer, only: :create

  respond_to :js
  respond_to :json, only: :create

	def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
	end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

	def destroy
	  @answer.destroy
  end

  def make_best
    @answer.make_best
  end

	private

  def publish_answer
    PrivatePub.publish_to "/questions/#{@question.id}/answers", answer: render_to_string(template: 'answers/show.json.jbuilder') if @answer.valid?
  end

	def load_question
		@question = Question.find(params[:question_id])
	end

	def load_answer
		@answer = Answer.find(params[:id])
	end

  def verify_owner
    @question = @answer.question
    redirect_to @question unless current_user.id == @answer.user_id
  end

  def verify_question_owner
    @question = @answer.question
    redirect_to @question unless current_user.id == @question.user_id
  end

	def answer_params
  	params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end
end