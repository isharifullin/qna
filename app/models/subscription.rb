class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :question

  validates :user, :question, presence: true
end