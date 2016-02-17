class QuestionsController < ApplicationController
  include Votable

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :verify_owner, only: [:destroy, :update]

  def index
  	@questions = Question.all
  end

  def show
    @answers = @question.answers
    @answer = @question.answers.build
  end

  def new
  	@question = Question.new
  end

  def create
  	@question = Question.new(question_params)
  	@question.user = current_user
  	if @question.save
      flash[:notice] = 'Your question successfully created.'
  		PrivatePub.publish_to "/questions/index", question: render_to_string(template: 'questions/show.json.jbuilder')
      redirect_to @question
  	else
  		render :new
  	end
  end

  def update
    @question.update(question_params)
  end

  def destroy
    @question.destroy
    flash[:notice] = 'Your question successfully deleted.'
    redirect_to questions_path
  end

  private 

  def load_question
  	@question = Question.find(params[:id])
  end

  def verify_owner
    redirect_to root_path  unless current_user.id == @question.user_id
  end

  def question_params
  	params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end
end
