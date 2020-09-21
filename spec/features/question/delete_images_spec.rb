require "rails_helper"

feature 'User can delete files of question' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user:user)}

  background do
    sign_in(user)
    visit root_path

    click_on 'Ask question'

    fill_in 'Title', with: "Test question"
    fill_in 'Body', with: "text text text"
    attach_file 'Files', "#{Rails.root}/spec/rails_helper.rb"

    click_on 'Ask'
  end

  describe 'Author of question' do
    scenario 'deletes files of question' do
      click_on 'Delete image'

      expect(page).to_not have_link "rails_helper.rb"
    end
  end

  describe 'Not Author of question' do
    scenario 'deletes files of question' do
      click_on 'Logout'

      user2 = create(:user)
      sign_in(user2)

      visit question_path(question)
      expect(page).to_not have_link 'Delete image'
    end

    scenario 'Anauthenticated user delets files of question' do
      click_on 'Logout'

      visit question_path(question)
      expect(page).to_not have_link 'Delete image'
    end
  end

end
