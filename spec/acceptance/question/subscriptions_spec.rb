require 'acceptance_helper.rb'

feature 'subscribe to the question', %q{
  In order to receive notifications about new answers 
  As authenticated user
  I want to be able subscribe to the question
} do

  given(:question) { create(:question) }
  
  describe 'Authenticated user' do
    given(:user) { create(:user) }
    given(:own_question) { create(:question, user: user) }
    scenario 'subscribes to the anothers question', js: true do
      sign_in(user)
      visit question_path(question)

      click_link 'Subscribe'
      
      expect(page).to have_link 'Unsubscribe'

      within '.subscribe_question' do
        expect(page).to have_text '1'
      end
    end

    context 'subscribed to the question' do
      given!(:subscription) { create(:subscription, question: question, user: user) }

      scenario 'user unsubscribes from the question', js: true do
        sign_in(user)
        visit question_path(question)
        click_link 'Unsubscribe'
        
        expect(page).to have_link 'Subscribe'
        within '.subscribe_question' do
          expect(page).to have_text '0'
        end
      end  
    end

    scenario 'tries subscribe to the own question', js: true do
      sign_in(user)
      visit question_path(own_question)

      expect(page).to_not have_link 'Subscribe'
      expect(page).to_not have_link 'Unsubscribe'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries subscribe to the question', js: true do
      visit question_path(question)

      expect(page).to_not have_link 'Subscribe'
      expect(page).to_not have_link 'Unsubscribe'
    end
  end
end