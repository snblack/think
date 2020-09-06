require "rails_helper"

feature 'User can delete answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user)}
  given(:answer) { create(:answer, user: user, question: question)}

  background do
    sign_in(user)
    visit question_path(answer.question)
  end

  scenario 'delete self answer' do
    click_on 'Delete answer'

    expect(page).to have_content 'Answer deleted'
    expect(page).to_not have_content answer.body
  end

  scenario 'tries delete not your question' do
    click_on 'Logout'

    user2 = create(:user)
    visit new_user_session_path

    sign_in(user2)

    visit question_path(question)

    expect(page).to have_no_content "Delete answer"
  end

  scenario 'tries delete not authenticated user' do
    click_on 'Logout'

    visit question_path(question)

    expect(page).to have_no_content "Delete answer"
  end
end
