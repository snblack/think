require 'rails_helper'

feature 'User can edit his answer' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:url) {'https://vk.com/feed'}

  describe 'Unauthenticated user' do
    scenario 'can not edit answer' do
      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end

    scenario "tries to edit other user's question", js: true do
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end

  describe 'Authenticated user' do
    scenario 'edits his answer', js: true do
      sign_in user
      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        fill_in 'Body', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'

        expect(page).to_not have_selector 'textarea'
      end
    end
    scenario 'edits his answer and add link', js: true do
      sign_in user
      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        fill_in 'Body', with: 'edited answer'
        click_on 'add link'

        fill_in 'Link name', with: 'My vk'
        fill_in 'Url', with: url

        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'

        expect(page).to_not have_selector 'textarea'
        expect(page).to have_link 'My vk', href:url
      end
    end

    scenario 'Author edits self answer and attached files', js: true do
      sign_in user
      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        fill_in 'Body', with: 'edited answer'
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

        click_on 'Save'

        expect(page).to have_link "rails_helper.rb"
        expect(page).to have_link "spec_helper.rb"
      end
    end

    scenario 'edits his answer with errors', js: true do
      sign_in user

      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content answer.body

        expect(page).to have_selector 'textarea'
      end

      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's question", js: true do
      user2 = create(:user)
      sign_in user2

      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end
