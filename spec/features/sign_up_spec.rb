require "rails_helper"

feature 'User can sign up' do

   scenario 'Unregistered user to sign up' do
    visit new_user_registration_path


    fill_in 'Email', with: "user#{rand(9999)}@test.com"
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'
    #Ожидания

    expect(page).to have_content 'Welcome! You have signed up successfully.'
   end

   scenario 'Registered user tries to sign up' do
     user = create(:user)

     visit new_user_registration_path
     fill_in 'Email', with: user.email
     fill_in 'Password', with: user.password
     fill_in 'Password confirmation', with: user.password
     click_on 'Sign up'

     expect(page).to have_content 'Email has already been taken'
   end
 end
