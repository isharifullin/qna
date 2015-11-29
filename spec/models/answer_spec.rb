require 'rails_helper'

RSpec.describe Answer, type: :model do

  let(:question) { create(:question) }
  let!(:answers) { create_list(:answer, 3, question: question) }
  let(:answer) { create(:answer, question: question) }

  describe "validaion tests" do
    it { should validate_presence_of :body }
    it { should validate_presence_of :question_id }
    it { should validate_presence_of :user_id }
  end

  describe "association tests" do
    it { should belong_to :user }
  	it { should belong_to :question }
    it { should have_many(:attachments).dependent(:destroy) } 
  end

  it { should accept_nested_attributes_for :attachments }

  describe 'default scope test' do
    it 'should show the best answer first' do
      expect(question.answers.first).to_not eq answer 
      
      answer.update(best: true)

      expect(question.answers.first).to eq answer 
    end
  end

  describe '#make_best' do
    it 'should set answer.best true' do
      answer.make_best

      expect(answer.best).to eq true 
    end

    it 'should set to other answers .best false' do
      answers.last.make_best
      answer.make_best
      
      answers.each do |other_answer|
        other_answer.reload

        expect(other_answer.best).to eq false
      end 
    end
  end
end 