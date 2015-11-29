require 'acceptance_helper'

feature 'Make best answer', %q{
  In order to identify the best solution
  As question owner
  I want to be able to choose best answer
} do 

  given!(:question_author) { create(:user) }
  given!(:another_user) { create(:user) }
  given!(:question) { create(:question, user: question_author) }
  given!(:answer) {create(:answer, question: question)}
  given!(:second_answer) {create(:answer, question: question)}

  describe 'Authenticated user' do
    before do
      sign_in question_author
    end

    scenario 'choose the best answer', js: true do
      visit question_path(question)
      within "#answer_#{answer.id}" do
        click_link 'Best'
        
        expect(page).to have_selector '#best_answer'
      end
    end

    scenario 'change the best answer', js: true do
      visit question_path(question)
      within "#answer_#{answer.id}" do
        click_link 'Best'
      end

      within "#answer_#{second_answer.id}" do
        click_link 'Best'
      end

      within "#answer_#{answer.id}" do
        expect(page).to_not have_selector '#best_answer'
      end

      within "#answer_#{second_answer.id}" do
        expect(page).to have_selector'#best_answer'
      end
    end
  end

  scenario 'Authenticated user tries to choose best answer in anothers question' do
    sign_in another_user
    visit question_path(question)
      
    expect(page).to_not have_link 'Best'
  end

  scenario 'Non-authenticated user tries to choose best answer' do
    visit question_path(question)
    
    expect(page).to_not have_link 'Best'
  end
end