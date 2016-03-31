class DailyDigestJob < ActiveJob::Base
  queue_as :default

  def perform
    User.find_each do |user|
      DailyMailer.digest(user).deliver
    end
  end
end
