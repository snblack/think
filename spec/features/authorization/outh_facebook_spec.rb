require "rails_helper"

feature 'user can autorization via facebook', js: true do
  background do
    visit new_user_session_path

    mock_auth_hash
  end

  scenario 'New user authorizes via facebook' do
    click_on 'Sign in with Facebook'

    expect(page).to have_content("Successfully authenticated from Facebook account.")
    expect(page).to have_content("Logout")

  end

  scenario 'Autorized user by facebook, tries authorizes via facebook', js: true do
    click_on 'Sign in with Facebook'

    expect(page).to have_content("Successfully authenticated from Facebook account.")
    click_on "Logout"
    click_on "Login"

    mock_auth_hash
    click_on 'Sign in with Facebook'

    expect(page).to have_content("Successfully authenticated from Facebook account.")
  end

  scenario 'Autorized user by email, tries authorizes via facebook', js: true do

    visit new_user_registration_path

    fill_in 'Email', with: 'mock_user@gmail.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content('Welcome! You have signed up successfully.')

    click_on "Logout"
    click_on "Login"


    click_on 'Sign in with Facebook'

    expect(page).to have_content("Successfully authenticated from Facebook account.")
    click_on "Logout"
    click_on "Login"

    mock_auth_hash
    click_on 'Sign in with Facebook'

    mock_auth_hash
    click_on 'Sign in with Facebook'

    expect(page).to have_content("Successfully authenticated from Facebook account.")
  end
end
