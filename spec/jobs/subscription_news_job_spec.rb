require 'rails_helper'

RSpec.describe SubscriptionNewsJob, type: :job do
  let!(:users) { create_list(:user, 2) }
  let!(:question) { create(:question, user: users.first) }
  let!(:answer) { create(:answer, question: question) }
  let!(:subsctiption) { create(:subscription, user: users.second, question: question) }

  it 'sends daily digest to subscribers and question owner' do
    users.each { |user| 
      expect(SubscriptionsMailer).to receive(:newsletter).with(user, answer).and_call_original 
    }
    SubscriptionNewsJob.perform_now(answer)
  end
end

