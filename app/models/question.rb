class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers, dependent: :destroy   
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: 'user'
  
  validates :title, :body, :user_id, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  scope :for_today, -> { where(created_at: Date.today.beginning_of_day..Date.today.end_of_day) }
end