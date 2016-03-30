class DailyMailer < ApplicationMailer
  def digest(user) 
    @questions = Question.for_today
    mail to: user.email
  end
end
