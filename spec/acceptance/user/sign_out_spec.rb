require 'acceptance_helper'

feature 'User sign out', %q{
  In order to be able finish work
  As an user
  I want to be able sign out
} do 

  given(:user) {create(:user)}

  scenario 'Authenticated user try to sign out' do
    sign_in(user)

    click_link 'sign_out_link'

    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end
end