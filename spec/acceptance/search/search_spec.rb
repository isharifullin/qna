require 'sphinx_helper'

feature 'Search', %q{
} do
  given!(:question) { create(:question, body: 'example question') }
  given!(:answer) { create(:answer, body: 'example answer') }
  given!(:comment) { create(:comment, commentable: question, body: 'example comment') }
  given!(:user) { create(:user, email: 'example@user.com') }
  
  before do
    index
    visit root_path
    
    fill_in "Query body", with: 'example'
    click_on 'Go'
  end
  
  scenario 'search everywhere' do
    expect(page).to have_link "#{question.title} #{question.body}"
    expect(page).to have_link answer.body
    expect(page).to have_link comment.body
    expect(page).to have_link user.email  
  end

  scenario 'blank query' do
    within '.search_form' do
      fill_in "Query body", with: ''
      click_on 'Go'
    end
    expect(page).to have_content 'Unable to find anythig on your request.'
  end

  scenario 'search not existing object' do
    within '.search_form' do
      fill_in "Query body", with: 'not existing question'
      click_on 'Go'
    end
    expect(page).to have_content 'Unable to find anythig on your request.'
  end  

  scenario 'search question' do
    within '.search_form' do
      fill_in "Query body", with: 'example'
      choose('search_query_query_object_question')

      click_on 'Go'
    end
    expect(page).to have_link "#{question.title} #{question.body}"
  end

  scenario 'search answer' do
    within '.search_form' do
      fill_in "Query body", with: 'example'
      choose('search_query_query_object_answer')

      click_on 'Go'
    end
    expect(page).to have_link answer.body
  end

  scenario 'search comment' do
    within '.search_form' do
      fill_in "Query body", with: 'example'
      choose('search_query_query_object_comment')

      click_on 'Go'
    end
    expect(page).to have_link comment.body
  end

  scenario 'search user' do
    within '.search_form' do
      fill_in "Query body", with: 'example'
      choose('search_query_query_object_user')

      click_on 'Go'
    end
    expect(page).to have_link user.email
  end

end