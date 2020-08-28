require "rails_helper"

feature 'user can browse question and answers of question' do
  given(:user) {create(:user)}

  scenario 'browses question' do
    question = create(:question)
    question.answers.create(body: 'test', user: user)

    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content question.answers[0].body
  end

end
