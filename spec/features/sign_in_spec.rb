require "rails_helper"

feature 'User can sign in', %q{
  In order to ask question
  As an unauthentificated User
  I'd like to be able to sign-in
 } do

   #Данные
   given(:user) {create(:user)}

   background { visit new_user_session_path }

   scenario 'Registered user tries to sign in' do
    # Действия
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    #Ожидания
    expect(page).to have_content 'Signed in successfully'
   end

   scenario 'Unregistered user tries to sign in' do
     fill_in 'Email', with: 'wrong@test.com'
     fill_in 'Password', with: '123456'
     click_on 'Log in'

     expect(page).to have_content 'Invalid Email or password.'
   end
 end
