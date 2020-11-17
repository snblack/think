require "rails_helper"

feature 'Ane user can subscribes on update answers of question', js:true do
  given(:user) {create(:user)}
  given(:question) {create(:question)}

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'user can subscribe question' do
      expect(page).to have_link 'Subscribe'
      click_on 'Subscribe'
      expect(page).to have_link 'Unsubscribe'
    end
  end

  describe 'Author' do
    given(:user) {create(:user)}
    given(:question) {create(:question, user: user)}

    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'user subscribed on question by default' do
      expect(page).to have_link 'Unsubscribe'
    end
  end

end
