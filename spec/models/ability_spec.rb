require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :menage, :all }

  end 

end