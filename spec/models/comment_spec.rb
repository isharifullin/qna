require 'rails_helper'

RSpec.describe Comment, type: :model do
  
  describe "validaion tests" do
    it { should validate_presence_of :body }
    it { should validate_presence_of :commentable }
    it { should validate_presence_of :user_id }
  end

  describe "association tests" do
    it { should belong_to :user }
    it { should belong_to :commentable }
  end

end
