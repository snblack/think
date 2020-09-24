require "rails_helper"

feature 'user can add links to answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:gist_url) {'https://gist.github.com/snblack/d1e5ea32044ca1439cf738d0db7587da'}

  scenario 'User adds link when asks answer', js: true do
    sign_in(user)
    visit question_path(question)

    within '.new-answer' do
      fill_in 'Body', with: 'My answer'
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url
    end

    click_on 'Post your answer'

    expect(page).to have_link 'My gist', href:gist_url

  end
end
