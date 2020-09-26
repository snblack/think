require "rails_helper"

feature 'user can add links to answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:gist_url) {'https://gist.github.com/snblack/d1e5ea32044ca1439cf738d0db7587da'}
  given(:gist_url2) {'https://gist.github.com/choco-bot/94bd0b3f1b441aaffad326fbdb754b5e'}
  given(:gist_url_invalid) {'invalidurl'}

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
  scenario 'User adds any links when asks answer', js: true do
    sign_in(user)
    visit question_path(question)

    within '.new-answer' do
      fill_in 'Body', with: 'My answer'
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url
      click_on 'add link'
    end

    within all('.nested-fields')[1] do
      fill_in 'Link name', with: 'My gist2'
      fill_in 'Url', with: gist_url2
    end

    click_on 'Post your answer'

    expect(page).to have_link 'My gist', href:gist_url
    expect(page).to have_link 'My gist2', href:gist_url2
  end
  scenario 'User adds any links when asks answer with invalid url', js: true do
    sign_in(user)
    visit question_path(question)

    within '.new-answer' do
      fill_in 'Body', with: 'My answer'
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url_invalid
      click_on 'add link'
    end

    click_on 'Post your answer'

    expect(page).to_not have_link 'My gist', href:gist_url_invalid
  end
end
