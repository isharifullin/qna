class DailyMailer < ApplicationMailer
  def digest(user) 
    @greeting = "Hi"
    @questions = Question.for_today
    mail to: user.email
  end
end
