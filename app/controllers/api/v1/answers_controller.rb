class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource 
  before_action :load_question, only: [:create, :index]

  def index
    respond_with @question.answers, each_serializer: Api::V1::Serializers::AnswersSerializer
  end

  def show
    respond_with Answer.find(params[:id])   
  end

  def create
    respond_with @question.answers.create(answer_params.merge(user: current_resoure_owner))
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end