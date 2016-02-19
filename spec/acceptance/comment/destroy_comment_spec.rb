require 'acceptance_helper'

feature 'Destroy comment for answer or question', %q{
  In order to fix mistakes
  As an authenticated user
  I want to be able to destroy comment for answer or question
} do

  given!(:user) { create(:user) }
  given!(:another_user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:question_comment) { create(:comment, commentable: question, user: user) }
  given!(:answer_comment) { create(:comment, commentable: answer, user: user) }

  describe 'Authenticated author' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'destroy own comment for question', js: true do
      within "#question_#{question.id}_comments" do
        within "#comment_#{question_comment.id}" do
          click_link 'Delete'
        end
        expect(page).to_not have_content 'My comment body'
      end 
      expect(current_path).to eq question_path(question)
    end

    scenario 'destroy own comment for answer', js: true do
      within "#answer_#{answer.id}_comments" do
        within "#comment_#{answer_comment.id}" do
          click_link 'Delete'
        end

        expect(page).to_not have_content 'My comment body'
      end
      expect(current_path).to eq question_path(question)
    end
  end

  describe 'Authenticated another_user' do
    before do
      sign_in(another_user)
      visit question_path(question)
    end

    scenario 'destroy own comment for question', js: true do
      within "#comment_#{question_comment.id}" do
        expect(page).to_not have_link 'Delete'
      end
    end

    scenario 'destroy own comment for answer', js: true do
      within "#comment_#{answer_comment.id}" do
        expect(page).to_not have_link 'Delete'
      end
    end
  end

  scenario 'Non-authenticated user tries to destroy comment' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete'
  end
end