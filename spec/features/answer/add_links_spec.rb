require "rails_helper"

feature 'user can add links to answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:url) {'https://vk.com/feed'}
  given(:url2) {'https://www.facebook.com/'}
  given(:gist_url) {'https://gist.github.com/snblack/9ff863f3ace404d31bf565ffddad832d'}
  given(:invalid_url) {'githubcom/choco-bot'}

  scenario 'User adds link when asks answer', js: true do
    sign_in(user)
    visit question_path(question)

    within '.new-answer' do
      fill_in 'Body', with: 'My answer'
      fill_in 'Link name', with: 'my vk'
      fill_in 'Url', with: url
    end

    click_on 'Post your answer'

    expect(page).to have_link 'my vk', href:url

  end
  scenario 'User adds any links when asks answer', js: true do
    sign_in(user)
    visit question_path(question)

    within '.new-answer' do
      fill_in 'Body', with: 'My answer'
      fill_in 'Link name', with: 'My vk'
      fill_in 'Url', with: url
      click_on 'add link'
    end

    within all('.nested-fields')[1] do
      fill_in 'Link name', with: 'My fb'
      fill_in 'Url', with: url2
    end

    click_on 'Post your answer'

    expect(page).to have_link 'My vk', href:url
    expect(page).to have_link 'My fb', href:url2
  end

  scenario 'User adds any links when asks answer with invalid url', js: true do
    sign_in(user)
    visit question_path(question)

    within '.new-answer' do
      fill_in 'Body', with: 'My answer'
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: invalid_url
      click_on 'add link'
    end

    click_on 'Post your answer'

    expect(page).to_not have_link 'My gist', href:invalid_url
  end

  scenario 'User adds link when asks answer with gist', js: true do
    sign_in(user)
    visit question_path(question)

    within '.new-answer' do
      fill_in 'Body', with: 'My answer'
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url
    end

    click_on 'Post your answer'
    expect(all('script').find { |s| s[:src].match /gist_url.js$/ })
  end
end
