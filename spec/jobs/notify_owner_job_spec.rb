require 'rails_helper'

RSpec.describe NotifyOwnerJob, type: :job do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question) }

  it 'sends notification to question owner' do
    expect(NotifyOwnerMailer).to receive(:notify_owner).with(answer).and_call_original 
    NotifyOwnerJob.perform_now(answer)
  end
end
