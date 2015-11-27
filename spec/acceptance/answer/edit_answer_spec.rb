require 'acceptance_helper'

feature 'Answer editing', %q{
  In order to fix mistake 
  As answer onwer
  I want to be able to edit answer
} do 
  
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) {create(:answer, question: question, user: user)}
  given!(:anothers_answer) {create(:answer, question: question)}

  scenario 'Non-authenticated user tries to edit answer' do
    visit question_path(question)
    
    expect(page).to_not have_link 'Edit' 
  end

  describe 'Authenticated user' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'edits his answer', js: true do
      within "#answer_#{answer.id}" do
        click_link 'Edit'
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'
      end

      within '.answers' do
        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'tries to edit anothers answer' do
      within "#answer_#{anothers_answer.id}" do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end