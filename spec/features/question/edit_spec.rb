require 'rails_helper'

feature 'User can edit question' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user:user) }

  scenario 'Unathenticated user can not edit question' do
    visit root_path

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits self answer', js: true do
      sign_in user
      visit root_path

      click_on 'Edit'

      within '.questions' do
        fill_in 'Title', with: 'edited title question'
        fill_in 'Body', with: 'edited body question'
        click_on 'Save'

        expect(page).to_not have_content question.title
        expect(page).to have_content 'edited title question'

        expect(page).to_not have_selector 'textarea'
      end

    end

    scenario 'edits self question with errors', js: true do
      sign_in user

      visit root_path

      click_on 'Edit'

      within '.questions' do
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

      visit root_path

      within '.questions' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end
