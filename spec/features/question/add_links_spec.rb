require "rails_helper"

feature 'user can add links to question' do
  given(:user) { create(:user) }
  given(:url) {'https://vk.com/feed'}
  given(:url2) {'https://www.facebook.com/'}
  given(:gist_url) {'https://gist.github.com/snblack/9ff863f3ace404d31bf565ffddad832d'}
  given(:gist_invalid_url) {'githubcom/choco-bot'}

  scenario 'User adds link when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My vk'
    fill_in 'Url', with: url

    click_on 'Ask'

    expect(page).to have_link 'My vk', href:url
  end

  scenario 'User adds any links when asks question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My vk'
    fill_in 'Url', with: url

    click_on 'add link'

    within all('.nested-fields')[1] do
      fill_in 'Link name', with: 'My fb'
      fill_in 'Url', with: url2
    end

    click_on 'Ask'

    expect(page).to have_link 'My vk', href:url
    expect(page).to have_link 'My fb', href:url2
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

  scenario 'User adds link when asks question with gist' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(all('script').find { |s| s[:src].match /gist_url.js$/ })
  end
end
