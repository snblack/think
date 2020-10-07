require "rails_helper"

feature 'user can see your reward' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:reward) {create(:reward, question:question, user:user)}

  scenario 'User can see your rewards' do
    sign_in(user)
    visit rewards_path

    expect(page).to have_content question.title
    expect(page).to have_content 'The best man'
    expect(page).to have_css("img[src*='reward.png']")
  end
end
