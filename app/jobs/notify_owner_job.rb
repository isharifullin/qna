class NotifyOwnerJob < ActiveJob::Base
  queue_as :default

  def perform(answer)  
    NotifyOwnerMailer.notify_owner(answer).deliver
  end
end
