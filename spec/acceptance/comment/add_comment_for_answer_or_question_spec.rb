require 'acceptance_helper'

feature 'Add comment for answer or question', %q{
  In order to help to solve the problem
  As an authenticated user
  I want to be able to add comment for answer or question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'creates comment for question', js: true do
      within "#question_#{question.id}_comments" do
        fill_in 'Your comment', with: 'My comment'
        click_on 'Create'
        expect(page).to have_content 'My comment'
      end
      expect(current_path).to eq question_path(question)
    end

    scenario 'tries to create invalid comment for question', js: true do
      within "#question_#{question.id}_comments" do
        click_on 'Create'
        expect(page).to_not have_content 'My comment'
      end
      expect(current_path).to eq question_path(question)
    end

    scenario 'creates comment for answer', js: true do
      within "#answer_#{answer.id}_comments" do
        fill_in 'Your comment', with: 'My comment'
        click_on 'Create'
        expect(page).to have_content 'My comment'
      end
      expect(current_path).to eq question_path(question)
    end

    scenario 'tries to create invalid comment for answer', js: true do
      within "#question_#{answer.id}_comments" do
        click_on 'Create'
        expect(page).to_not have_content 'My comment'
      end
      expect(current_path).to eq question_path(question)
    end
  end

  scenario 'Non-authenticated user tries to create answer' do
    visit question_path(question)

    expect(page).to_not have_selector('.new_comment')
  end
end