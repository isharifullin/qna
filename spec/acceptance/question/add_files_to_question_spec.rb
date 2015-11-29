require 'acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate question
  As an question's author
  I want to be able to attach files to question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
 
  background { sign_in(user) }

  describe 'when create question' do
    before { visit new_question_path }

    scenario 'User adds file', js: true do
      fill_in 'Title', with: 'MyString'
      fill_in 'Body', with: 'MyText'

      click_link 'Add file'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

      click_on 'Create'

      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end 

    scenario 'User adds several files', js: true do
      fill_in 'Title', with: 'MyString'
      fill_in 'Body', with: 'MyText'

      click_link 'Add file'
      click_link 'Add file'

      all("input[type='file']").first.set("#{Rails.root}/spec/spec_helper.rb")
      all("input[type='file']").last.set("#{Rails.root}/spec/acceptance_helper.rb")

      click_on 'Create'

      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'acceptance_helper.rb', href: '/uploads/attachment/file/2/acceptance_helper.rb'
    end
  end

  describe 'when edit question' do
    before { visit question_path(question) }

    scenario 'User adds file', js: true do   
      within '.question' do
        click_link 'Edit'
        
        fill_in 'Title', with: 'MyString'
        fill_in 'Body', with: 'MyText'

        click_link 'Add file'
        attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

        click_on 'Save'

        expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      end
    end 

    scenario 'User adds several files', js: true do
      within '.question' do
        click_link 'Edit'

        fill_in 'Title', with: 'MyString'
        fill_in 'Body', with: 'MyText'

        click_link 'Add file'
        click_link 'Add file'

        all("input[type='file']").first.set("#{Rails.root}/spec/spec_helper.rb")
        all("input[type='file']").last.set("#{Rails.root}/spec/acceptance_helper.rb")

        click_on 'Save'

        expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
        expect(page).to have_link 'acceptance_helper.rb', href: '/uploads/attachment/file/2/acceptance_helper.rb'
      end
    end
  end
end