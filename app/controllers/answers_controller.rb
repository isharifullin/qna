class AnswersController < ApplicationController
  before_action :authenticate_user!
	before_action :load_question
  before_action :verify_question_owner, only: [:make_best]
	before_action :verify_owner, only: [:update, :destroy]
  
	def new
		@answer = @question.answers.new
	end

	def create 
		@answer = @question.answers.new(answer_params)
		@answer.user = current_user
		@answer.save 
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
		@answer = @question.answers.find(params[:id])
	end

  def verify_owner
  	load_answer
    redirect_to @question unless current_user.id == @answer.user_id
  end

  def verify_question_owner
    load_answer
    redirect_to @question unless current_user.id == @question.user_id
  end

	def answer_params
  	params.require(:answer).permit(:body, attachments_attributes: [:file])
  end
end