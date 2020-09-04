require "rails_helper"

feature 'user can create answer for question', %q{
  The user, while on the question page,
   can write an answer to a question (i.e. a new
   the answer should be right on the question page,
   without going to another page)
} do

  given(:user) { create(:user) }

  scenario 'to answer' do
    sign_in(user)
    question = create(:question, user: user)
    visit question_path(question)

    fill_in 'Body', with: "text text text"
    click_on 'Post your answer'

    expect(page).to have_content question.answers[0].body
  end

  scenario 'Unauthenticated user tries to answer' do
    question = create(:question)
    visit question_path(question)

    fill_in 'Body', with: "text text text"
    click_on 'Post your answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'validation errors are shown' do
    sign_in(user)
    question = create(:question)
    visit question_path(question)

    click_on 'Post your answer'

    expect(page).to have_content 'Question can not empty!'
  end

end
