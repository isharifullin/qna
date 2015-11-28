class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question
  
  validates :body, :question_id, :user_id, presence: true

  default_scope { order('best DESC','created_at') } 

  def make_best
    question.transaction do
      question.answers.update_all(best: false)
      update(best: true)  
    end
  end
end
