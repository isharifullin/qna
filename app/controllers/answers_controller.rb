class AnswersController < ApplicationController
  include Votable

  before_action :authenticate_user!
  before_action :load_question, only: [:new, :create]
	before_action :load_answer, only: [:update, :destroy, :make_best]
  before_action :verify_owner, only: [:update, :destroy]
  before_action :verify_question_owner, only: [:make_best]
  
	def new
		@answer = @question.answers.new
	end

	def create
		@answer = @question.answers.new(answer_params)
		@answer.user = current_user
    if @answer.save
      render json: render_to_string(template: 'answers/show.json.jbuilder')
    else
      render json: @answer.errors.full_messages, status: :unprocessable_entity
    end
	end

  def update
    @answer.update(answer_params)
  end

	def destroy
	  @answer.destroy
  end

  def make_best
    @answer.make_best
  end

	private

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