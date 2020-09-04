require "rails_helper"

feature 'user can browse question and answers of question' do
  given(:user) {create(:user)}
  given(:question) {create(:question)}

  scenario 'browses question' do
    question.answers = create_list(:answer, 5, question: question, user: user)

    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    question.answers do |answer|
      expect(page).to have_content answer.body
    end
  end

end
