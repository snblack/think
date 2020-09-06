require "rails_helper"

feature 'User can log out' do

   background { visit new_user_session_path }

   scenario 'Authenticated user logout' do
    user = create(:user)
    visit new_user_session_path

    # Действия
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    click_on 'Logout'
    #Ожидания
    expect(page).to have_content 'Signed out successfully.'
   end

 end
