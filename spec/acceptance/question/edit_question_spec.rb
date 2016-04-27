require 'acceptance_helper'

feature 'Question editing', %q{
  In order to fix mistake 
  As question onwer
  I want to be able to edit question
} do 
  
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:anothers_question) { create(:question) }

  describe 'Authenticated user' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'edits his question', js: true do
      within ".question" do
        click_link 'Edit'
        fill_in 'Title', with: 'edited title'
        fill_in 'Body', with: 'edited body'
        click_on 'Save'
      end
      expect(page).to_not have_content question.title 
      expect(page).to_not have_content question.body
      within '.question' do
        expect(page).to have_content 'edited title'
        expect(page).to have_content 'edited body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'tries to edit anothers answer' do
      visit question_path(anothers_question)
      
      expect(page).to_not have_link 'Edit' 
    end
  end

  scenario 'Non-authenticated user tries to edit question' do 
    visit question_path(question)
    
    expect(page).to_not have_link 'Edit' 
  end
end