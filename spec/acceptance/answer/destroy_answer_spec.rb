require 'rails_helper'

feature 'Destroy answer', %q{
  In order to remove useless information
  As answer owner
  I want to be able to destroy answer
} do 

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, user: user, question: question) }
  given!(:another_user) { create(:user) }

  scenario 'Authenticated user destroes own answer' do
    sign_in(user)
    visit question_path(question)

    click_on 'Delete'

    expect(page).to have_content 'Your answer successfully deleted.'
    expect(current_path).to eq question_path(question)
  end

  scenario 'Authenticated user tries to destroy anothers answer' do    
    sign_in(another_user  )
    visit question_path(question)

    expect(page).to_not have_link 'Delete'
  end

  scenario 'Non-authenticated user tries to destroy answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete'
  end

end