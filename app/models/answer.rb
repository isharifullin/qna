class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  
  validates :body, :question_id, :user_id, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  default_scope { order('best DESC','created_at') } 

  after_save :send_newsletter

  def make_best
    Answer.transaction do
      question.answers.update_all(best: false)
      update!(best: true)  
    end
  end

  private

  def send_newsletter
    SubscriptionNewsJob.perform_later(self)
  end
end