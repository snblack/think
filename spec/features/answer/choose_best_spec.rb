require "rails_helper"

feature 'user can choose the best answer for self question' do
  given!(:user) { create(:user) }
  given!(:question) {create(:question, user: user)}
  given!(:answer) {create(:answer, question: question)}

  describe 'for author of question' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'chooses the best answer', js: true do
      click_on 'Choose answer'

      expect(page).to have_content 'the best answer'
      expect(page).to_not have_link 'Choose answer'
    end

    scenario 'question with label the best answer First', js: true do
      create(:answer, question: question)

      visit question_path(question)

      page.all('.best-answer-link')[1].click

      answers = page.all('.answers')
      expect(answers[0]).to have_content 'the best answer'
    end

    scenario 'chooses another answer the best', js: true do
      create(:answer, question: question)

      visit question_path(question)

      page.all('.best-answer-link')[1].click

      expect(page.assert_text(:visible, 'the best answer', count: 1 ))
    end
  end

  describe 'for no author' do
    scenario 'User not author of question can not choose the best answer', js: true do
      user2 = create(:user)
      sign_in(user2)

      visit questions_path(question)

      expect(page).to_not have_link 'Choose answer'
    end
  end
end
