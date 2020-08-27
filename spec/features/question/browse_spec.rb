require "rails_helper"

feature 'user can browse question and answers of question' do

  scenario 'browses question' do
    question = create(:question)
    question.answers.create(body: 'test')

    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content question.answers[0].body
  end

end
