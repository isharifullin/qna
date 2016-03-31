class NotifyOwnerMailer < ApplicationMailer
  def notify_owner(answer)
    @answer = answer
    @question = answer.question
    mail to: @question.user.email
  end
end
