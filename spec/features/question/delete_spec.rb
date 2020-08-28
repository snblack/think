require "rails_helper"

feature 'User can delete question' do
  background do
    user = create(:user)
    visit new_user_session_path

    # Действия
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    click_on 'Ask question'

    fill_in 'Title', with: "Test question"
    fill_in 'Body', with: "text text text"
    click_on 'Ask'
  end

  scenario 'delete your question' do
    click_on 'Delete question'

    expect(page).to have_content 'Question deleted'
  end

  scenario 'tries delete not your question' do
    click_on 'Logout'

    user2 = create(:user)
    visit new_user_session_path

    # Действия
    fill_in 'Email', with: user2.email
    fill_in 'Password', with: user2.password
    click_on 'Log in'

    visit question_path(Question.first)

    click_on 'Delete question'

    expect(page).to have_content "You can't dalete this question"
  end
end
