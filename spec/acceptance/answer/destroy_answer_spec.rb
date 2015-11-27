require 'acceptance_helper'

feature 'Destroy answer', %q{
  In order to remove useless information
  As answer owner
  I want to be able to destroy answer
} do 

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }
  given!(:anothers_answer) { create(:answer, question: question) }

  describe 'Authenticated user' do
    before do 
      sign_in(user)
      visit question_path(question)
    end 

    scenario 'destroes own answer', js: true do
      within "#answer_#{answer.id}" do
        click_link 'Delete'
      end

      expect(current_path).to eq question_path(question)
      expect(page).to_not have_content answer.body
    end

    scenario 'tries to destroy anothers answer' do    
      within "#answer_#{anothers_answer.id}" do
        expect(page).to_not have_link 'Delete'
      end
    end
  end

  scenario 'Non-authenticated user tries to destroy answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete'
  end
end