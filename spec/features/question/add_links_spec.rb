require "rails_helper"

feature 'user can add links to question' do
  given(:user) { create(:user) }
  given(:gist_url) {'https://gist.github.com/snblack/d1e5ea32044ca1439cf738d0db7587da'}

  scenario 'User adds link when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href:gist_url
  end

end
