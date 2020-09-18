require 'rails_helper'

feature 'User can edit question' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user:user) }

  describe 'Unauthenticated user' do
    scenario 'can not edit question' do
      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end
    scenario "tries to edit other user's question", js: true do
      visit root_path

      within '.questions' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end

  describe 'Authenticated user' do
    scenario 'Author edits self question', js: true do
      sign_in user
      visit question_path(question)

      click_on 'Edit'

      within '.question' do
        fill_in 'Title', with: 'edited title question'
        fill_in 'Body', with: 'edited body question'
        click_on 'Save'

        expect(page).to_not have_content question.title
        expect(page).to have_content 'edited title question'

        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'Author edits self question and attached files', js: true do
      sign_in user
      visit question_path(question)

      click_on 'Edit'

      within '.question' do
        fill_in 'Title', with: 'edited title question'
        fill_in 'Body', with: 'edited body question'
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link "rails_helper.rb"
        expect(page).to have_link "spec_helper.rb"
      end
    end

    scenario 'edits self question with errors', js: true do
      sign_in user

      visit question_path(question)

      click_on 'Edit'

      within '.question' do
        fill_in 'Title', with: ''
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content question.title
        expect(page).to have_selector 'textarea'
      end

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's question", js: true do
      user2 = create(:user)
      sign_in user2

      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end
  end
end
