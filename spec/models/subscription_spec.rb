require 'rails_helper'

RSpec.describe Subscription, type: :model do
  describe "validaion tests" do
    it { should validate_presence_of :question }
    it { should validate_presence_of :user }
  end

  describe "association tests" do
    it { should belong_to :user }
    it { should belong_to :question }
  end

end
