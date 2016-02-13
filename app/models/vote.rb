class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :user_id, presence: true, uniqueness: { scope: [:votable_type, :votable_id] }
  validates :votable, :value, presence: true
  validates :value, inclusion: { in: [-1, 1] }

  scope :upvotes, -> { where(value: 1) }
  scope :downvotes, -> { where(value: -1) }

  def self.rating
    sum(:value)
  end
end
