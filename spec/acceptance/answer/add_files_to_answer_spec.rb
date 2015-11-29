require 'acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate answer
  As an answer's author
  I want to be able to attach files to answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background { sign_in(user) }

  describe 'when create answer' do
    before { visit question_path(question) }

    scenario 'User adds file', js: true do
      fill_in 'Your answer', with: 'MyText'

      click_link 'Add file'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      
      click_on 'Post your answer'

      within '.answers' do
        expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      end
    end

    scenario 'User adds several files', js: true do
      fill_in 'Your answer', with: 'MyText'

      click_link 'Add file'
      click_link 'Add file'

      all("input[type='file']").first.set("#{Rails.root}/spec/spec_helper.rb")
      all("input[type='file']").last.set("#{Rails.root}/spec/acceptance_helper.rb")

      click_on 'Post your answer'
      
      within '.answers' do
        expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
        expect(page).to have_link 'acceptance_helper.rb', href: '/uploads/attachment/file/2/acceptance_helper.rb'
      end
    end
  end

  describe 'when edit answer' do
    given!(:answer) { create(:answer, question: question, user: user) }

    before { visit question_path(question) }

    scenario 'User adds file', js: true do
      within "#answer_#{answer.id}" do
        click_link 'Edit'
        fill_in 'Your answer', with: 'MyText'

        click_link 'Add file'
        attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
        
        click_on 'Save'

        expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      end
    end 

    scenario 'User adds several files', js: true do
      within "#answer_#{answer.id}" do
        click_link 'Edit'
        fill_in 'Your answer', with: 'MyText'

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