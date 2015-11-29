class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question
  has_many :attachments, as: :attachable, dependent: :destroy
  
  validates :body, :question_id, :user_id, presence: true

  accepts_nested_attributes_for :attachments

  default_scope { order('best DESC','created_at') } 

  def make_best
    Answer.transaction do
      question.answers.update_all(best: false)
      update!(best: true)  
    end
  end
end