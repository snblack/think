require "rails_helper"

feature 'User can delete question' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user:user)}

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'delete self question' do
    click_on 'Delete'

    expect(page).to have_content 'Question deleted'
    expect(page).to_not have_content question.title
  end

  scenario 'tries delete not your question' do
    click_on 'Logout'

    user2 = create(:user)
    visit new_user_session_path

    sign_in(user2)

    visit question_path(question)

    expect(page).to have_no_link "Delete question"
  end

  scenario 'tries delete not authenticate' do
    click_on 'Logout'

    visit question_path(question)

    expect(page).to have_no_link "Delete question"
  end
end
