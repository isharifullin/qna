class AnswersController < ApplicationController
  before_action :authenticate_user!
	before_action :load_question
	before_action :load_answer, only: [:destroy]

	def new
		@answer = @question.answers.new
	end

	def create 
		@answer = @question.answers.new(answer_params)
		@answer.user = current_user
		if @answer.save 
			flash[:notice] = 'Your answer successfully created.'
			redirect_to @question
		else
			flash[:notice] = 'Your answer has not been created.'
			render 'questions/show'
		end
	end

	def destroy
		if @answer.user = current_user
	    @answer.destroy
	    flash[:notice] = 'Your answer successfully deleted.'
	    redirect_to @question
	  else 
	  	redirect_to @question
	  end
  end

	private

	def load_question
		@question = Question.find(params[:question_id])
	end

	def load_answer
		@answer = @question.answers.find(params[:id])
	end

	def answer_params
  	params.require(:answer).permit(:body, :question_id)
  end
end
