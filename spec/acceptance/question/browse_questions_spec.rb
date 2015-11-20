require 'rails_helper'

feature 'User browses a list of questions', %q{
  In order to be able to answer for questions and find questions
  As an user
  I want to be able to browse list of questions
} do

  given!(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3, user: user) }

  scenario 'User browses a list of questions' do
    visit questions_path

    questions.each { |question| expect(page).to have_content question.title }
  end
end