require 'rails_helper'

feature 'User browses a question', %q{
  In order to be able to find answer for question
  As an user
  I want to be able to browse a question
} do 

  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }
  scenario 'User browses a question' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each { |answer| expect(page).to have_content answer.body }
  end
end