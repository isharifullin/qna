require 'acceptance_helper'

feature 'Sign in with twitter account', %q{
  In order to use account in the social network for authentication
  As an non-authenticated user
  I want to be able to sign in with twitter account
} do
  
  before { visit new_user_session_path }
  describe 'with valid credentials' do
    context 'the first sign in' do
      context 'user not exist' do
        it "can sign in user with Twitter account" do
          mock_auth_hash(:twitter)
          click_link "Sign in with Twitter"
          expect(page).to have_content("To complete the sign up enter email.")
          fill_in 'auth_info_email', with: 'test@test.com'
          click_on 'Submit'
          expect(page).to have_content("Successfully authenticated from Twitter account.")
          expect(page).to have_content("Sign out")
        end
      end

      context 'user already exists' do
        let!(:user) { create(:user, email: 'test@test.com') }
        let!(:question) { create(:question, user: user) }
        it "can sign in user with Twitter account" do
          mock_auth_hash(:twitter)
          click_link "Sign in with Twitter"
          expect(page).to have_content("To complete the sign up enter email.")
          fill_in 'auth_info_email', with: 'test@test.com'
          click_on 'Submit'
          expect(page).to have_content("Successfully authenticated from Twitter account.")
          expect(page).to have_content("Sign out")

          visit question_path(question)
          expect(page).to have_link "Delete"
        end
      end
    end
    
    context 'not the first authorization' do
      let!(:user) { create(:user) }
      let!(:authorization) { create(:authorization, user: user, provider: 'twitter') }
      let!(:question) { create(:question, user: user) }
      
      it "can sign in user with Twitter account" do
        mock_auth_hash(:twitter)
        click_link "Sign in with Twitter"
        expect(page).to have_content("Successfully authenticated from Twitter account.")
        expect(page).to have_content("Sign out")
        visit question_path(question)
        expect(page).to have_link "Delete"
      end   
    end
  end

  describe 'with invalid credentials' do
    it "can handle authentication error" do
      OmniAuth.config.mock_auth[:twitter] = :invalid_credential
      click_link "Sign in with Twitter"
      expect(page).to have_content("Could not authenticate you from Twitter because")
    end
  end
end