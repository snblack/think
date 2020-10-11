require "rails_helper"

feature 'user can vote for question/answer' do
  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:self_question) { create(:question, user: user) }
  given!(:question) { create(:question, user: user2) }
  given!(:self_answer) { create(:answer, question: self_question, user: user)}
  given!(:answer) { create(:answer, question: question, user: user2)}

  describe 'Not Author' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'Authenticate user can vote for answer', js: true do
      within '.answers' do
        click_on 'Up'
        expect(page).to have_content '1'
      end
    end


    scenario 'User can vote only one times for answer', js: true do
      within '.answers' do
        click_on 'Up'
        expect(page).to have_content '1'
        expect(page).to_not have_link 'Up'
      end
    end

    scenario 'User can cancel vote and vote again for answer', js: true do
      within '.answers' do
        click_on 'Up'
        expect(page).to have_content '1'
        click_on 'Down'
        expect(page).to have_content '-1'
        click_on 'Up'
        expect(page).to have_content '1'
      end
    end
  end

  describe 'Author' do
    background do
      sign_in(user)

      visit question_path(self_question)
    end

    scenario 'User can not vote for self answer', js: true do
      within '.answers' do
        click_on 'Up'
        expect(page).to have_content '0'
      end
    end

  end
end
