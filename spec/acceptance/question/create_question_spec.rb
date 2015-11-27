require 'acceptance_helper'

feature 'Create question', %q{
	In order to get answer from community
	As authenticated user
	I want to be able to ask questions  
	} do
		
	given(:user) {create(:user)}

	scenario 'Authenticated user creates question' do
		sign_in(user)
		visit questions_path
		
		click_on 'Ask question'
		fill_in 'Title', with: 'MyString'
		fill_in 'Body', with: 'MyText'
		click_on 'Create'

		expect(page).to have_content 'Your question successfully created.'
	end
		
	scenario 'Non-authenticated user tries to create question' do
 		visit questions_path
 		
		expect(page).to_not have_link 'Ask question'
	end
end