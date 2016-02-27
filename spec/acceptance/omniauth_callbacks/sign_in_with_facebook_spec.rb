require 'acceptance_helper'

feature 'Sign in with facebook account', %q{
  In order to use account in the social network for authentication
  As an non-authenticated user
  I want to be able to sign in with facebook account
} do
  
  before { visit new_user_session_path }
  context 'the first sign in' do
    context 'with valid credentials' do
      context 'user not exist' do
        it "can sign in user with Facebook account" do
          mock_auth_hash(:facebook)
          click_link "Sign in with Facebook"
          page.should have_content("Successfully authenticated from Facebook account.")
          page.should have_content("Sign out")
        end
      end
      context 'user already exists' do
        let!(:user) { create(:user, email: 'test@test.com') }
        let!(:question) { create(:question, user: user) }
        it "can sign in user with Facebook account" do
          mock_auth_hash(:facebook)
          click_link "Sign in with Facebook"
          expect(page).to have_content("Successfully authenticated from Facebook account.")
          expect(page).to have_content("Sign out")

          visit question_path(question)
          expect(page).to have_link "Delete"
        end
      end
    end
  end

  context 'not the first authorization' do
    let!(:user) { create(:user) }
    let!(:authorization) { create(:authorization, user: user, provider: 'Facebook') }

    it "can sign in user with Facebook account" do
      mock_auth_hash(:facebook)
      click_link "Sign in with Facebook"
      expect(page).to have_content("Successfully authenticated from Facebook account.")
      expect(page).to have_content("Sign out")
    end
  end

  context 'with invalid credentials' do
    it "can handle authentication error" do
      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
      click_link "Sign in with Facebook"
      page.should have_content("Could not authenticate you from Facebook because \"Invalid credentials\".")
    end
  end
end