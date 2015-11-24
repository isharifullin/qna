require 'rails_helper'

feature 'Create answer', %q{
  In order to help to solve the problem
  As authenticated user
  I want to be able to create answer
} do 

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Authenticated user creates answer', js: true do
    sign_in(user)

    visit question_path(question)
    fill_in 'Your answer', with: 'My answer'
    click_on 'Post your answer'

    within '.answers' do
      expect(page).to have_content 'My answer'
    end
    expect(current_path).to eq question_path(question)
  end

  scenario 'Non-authenticated user tries to create answer' do
    visit question_path(question)
    fill_in 'Your answer', with: 'My answer'
    click_on 'Post your answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end