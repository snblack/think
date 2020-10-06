require "rails_helper"

feature 'user can choose answer for reward' do
  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user2)}
  given!(:reward) {create(:reward, question:question)}

  scenario 'Author can choose answer for reward', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'Choose answer'

    within '.answers' do
      expect(page).to have_content 'The best man'
      expect(page).to have_css("img[src*='reward.png']")
    end

  end
end
