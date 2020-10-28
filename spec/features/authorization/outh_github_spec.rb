require "rails_helper"

feature 'user can autorization via github', js: true do
  background do
    visit new_user_session_path

    mock_auth_hash
  end

  scenario 'New user authorizes via GitHub' do
    click_on 'Sign in with GitHub'

    expect(page).to have_content("Successfully authenticated from Github account.")
    expect(page).to have_content("Logout")

  end

  scenario 'Autorized user by Github, tries authorizes via GitHub', js: true do
    click_on 'Sign in with GitHub'

    expect(page).to have_content("Successfully authenticated from Github account.")
    click_on "Logout"
    click_on "Login"

    mock_auth_hash
    click_on 'Sign in with GitHub'

    expect(page).to have_content("Successfully authenticated from Github account.")
  end

  scenario 'Autorized user by email, tries authorizes via GitHub', js: true do

    visit new_user_registration_path

    fill_in 'Email', with: 'mock_user@gmail.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content('Welcome! You have signed up successfully.')

    click_on "Logout"
    click_on "Login"


    click_on 'Sign in with GitHub'

    expect(page).to have_content("Successfully authenticated from Github account.")
    click_on "Logout"
    click_on "Login"

    mock_auth_hash
    click_on 'Sign in with GitHub'

    mock_auth_hash
    click_on 'Sign in with GitHub'

    expect(page).to have_content("Successfully authenticated from Github account.")
  end
end
