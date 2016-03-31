class QuestionsController < ApplicationController
  include Votable
  
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, except: [:index, :new, :create]
  after_action :publish_question, only: :create

  authorize_resource

  respond_to :html

  def index
  	respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    respond_with(@question = Question.create(question_params.merge(user: current_user)))
  end

  def update
    @question.update(question_params)
  end

  def destroy
    respond_with(@question.destroy)
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

  def publish_question
    PrivatePub.publish_to "/questions/index", question: render_to_string(template: 'questions/show') if @question.valid?
  end

  def load_question
  	@question = Question.find(params[:id])
  end

  def question_params
  	params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end
end
