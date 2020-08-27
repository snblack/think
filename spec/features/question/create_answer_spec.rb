require "rails_helper"

feature 'user can create answer for question', %q{
  Пользователь, находясь на странице вопроса,
  может написать ответ на вопрос (т.е. форма нового
  ответа должна быть прямо на странице вопроса,
  без перехода на другую страницу)
} do

  scenario 'to answer' do
    user = create(:user)
    sign_in(user)

    question = create(:question)
    visit question_path(question)

    click_on 'to answer'

    fill_in 'Body', with: "text text text"
    click_on 'Post your answer'

    expect(page).to have_content question.answers[0].body
  end

  scenario 'Unauthenticated user tries to answer' do
    question = create(:question)
    visit question_path(question)

    click_on 'to answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'

  end

end
