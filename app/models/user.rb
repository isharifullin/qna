class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable,
         :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  def vote_for(object, value)
    vote = self.votes.new(votable: object, value: value)
    vote.save unless voted_for?(object)
  end

  def unvote_for(object)
    self.votes.where(votable: object).delete_all
  end

  def voted_for?(object)
    self.votes.where(votable: object).exists?
  end

  def subscribe(question)
    subscription = subscriptions.new(question_id: question.id) 
    subscription.save! unless subscribed_for?(question)
  end

  def unsubscribe(question)
    subscriptions.where(question_id: question.id).delete_all
  end

  def subscribed_for?(question)
    subscriptions.where(question_id: question.id).exists?
  end 

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization
    
    unless auth.info.try(:email)
      return false
    else
      email = auth.info.email 
      user = User.where(email: email).first
      unless user         
        password = Devise.friendly_token[0, 20]
        user = User.create!(email: email, password: password, password_confirmation: password)
      end
      user.authorizations.create!(provider: auth.provider, uid: auth.uid)
      user
    end
  end
end