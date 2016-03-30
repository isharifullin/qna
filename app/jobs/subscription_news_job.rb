class SubscriptionNewsJob < ActiveJob::Base
  queue_as :default

  def perform(answer)
    SubscriptionsMailer.newsletter(answer.question.user, answer).deliver
    
    subscribers = answer.question.subscribers
    subscribers.each do |user|
      SubscriptionsMailer.newsletter(user, answer).deliver
    end
  end
end
