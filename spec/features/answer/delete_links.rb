require "rails_helper"

feature 'User can delete links of asnwer', js: true do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user)}

  background do
    sign_in(user)
    visit question_path(question)

    within '.new-answer' do
      fill_in 'Body', with: "text text text"
      fill_in 'Link name', with: 'vk link'
      fill_in 'Url', with: 'https://www.vk.com/'
    end

    click_on 'Post your answer'
  end

  describe 'Author of answer' do
    scenario 'deletes links of answer' do
      click_on 'Delete link'

      expect(page).to_not have_content "vk link"
    end
  end

  describe 'Not Author of answer' do
    scenario 'deletes link of asnwer' do
      click_on 'Logout'

      user2 = create(:user)
      sign_in(user2)

      visit question_path(question)
      expect(page).to_not have_link 'Delete link'
    end

    scenario 'Anauthenticated user delets files of question' do
      click_on 'Logout'

      visit question_path(question)
      expect(page).to_not have_link 'Delete link'
    end
  end

end
