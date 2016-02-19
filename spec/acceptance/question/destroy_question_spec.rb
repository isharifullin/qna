require 'acceptance_helper'

feature 'Destroy question', %q{
  In order to remove useless information
  As question owner
  I want to be able to destroy question
} do 

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:another_user) { create(:user) }

  scenario 'Authenticated user destroes own answer' do
    sign_in(user)
    visit question_path(question)
    
    within '.question' do
      click_link 'Delete'
    end

    expect(page).to have_content 'Question was successfully destroyed.'
    expect(current_path).to eq questions_path
  end

  scenario 'Authenticated user tries to destroy anothers question' do    
    sign_in(another_user)
    visit question_path(question)

    within '.question' do 
      expect(page).to_not have_link 'Delete'
    end
  end

  scenario 'Non-authenticated user tries to destroy question' do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Delete'
    end
  end
end