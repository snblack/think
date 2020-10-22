require "rails_helper"

feature 'user can add comment for answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  scenario 'Authenticated user adds comment to answer', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answer-comments' do
      fill_in 'Comment', with: 'My comment'
      click_on 'add comment'
    end

    expect(page).to have_content 'My comment'
  end

  scenario 'Unauthenticated user tries add comment to answer', js: true do
    visit question_path(question)

    within '.answer-comments' do
      expect(page).to_not have_link 'add comment'
    end
  end

  context "mulitple sessions" do
    scenario "comment appears on another user's page", js:true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.answer-comments' do
          fill_in 'Comment', with: 'My comment'
          click_on 'add comment'
        end

        expect(page).to have_content 'My comment'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'My comment'
      end
    end
  end
end
