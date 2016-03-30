class SubscriptionsMailer < ApplicationMailer
  def newsletter(user, answer)
    @answer = answer
    @question = answer.question
    mail to: user.email
  end
end
