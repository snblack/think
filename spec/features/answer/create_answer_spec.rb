require "rails_helper"

feature 'user can create answer for question', %q{
  The user, while on the question page,
   can write an answer to a question (i.e. a new
   the answer should be right on the question page,
   without going to another page)
} do

  given(:user) { create(:user) }
  given(:question) {create(:question, user: user)}

  scenario 'Authenticate user create answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: "text text text"
    click_on 'Post your answer'

    expect(page).to have_content 'text text text'
  end

  scenario 'Unauthenticated user tries to answer' do
    question = create(:question)
    visit question_path(question)

    fill_in 'Body', with: "text text text"
    click_on 'Post your answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'Authenticate user create answer with error', js: true do
    sign_in(user)
    question = create(:question)
    visit question_path(question)

    click_on 'Post your answer'

    expect(page).to have_content "Body can't be blank"
  end

end
