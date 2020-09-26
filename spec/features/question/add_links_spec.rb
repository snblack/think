require "rails_helper"

feature 'user can add links to question' do
  given(:user) { create(:user) }
  given(:gist_url) {'https://gist.github.com/snblack/d1e5ea32044ca1439cf738d0db7587da'}
  given(:gist_url2) {'https://gist.github.com/choco-bot/94bd0b3f1b441aaffad326fbdb754b5e'}
  given(:gist_invalid_url) {'githubcom/choco-bot'}

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

  scenario 'User adds any links when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'add link'

    within all('.nested-fields')[1] do
      fill_in 'Link name', with: 'My gist2'
      fill_in 'Url', with: gist_url2
    end

    click_on 'Ask'

    expect(page).to have_link 'My gist', href:gist_url
    expect(page).to have_link 'My gist2', href:gist_url2
  end

  scenario 'User adds link when asks question with invalid url' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_invalid_url

    click_on 'Ask'

    expect(page).to_not have_link 'My gist', href:gist_invalid_url
  end
end
