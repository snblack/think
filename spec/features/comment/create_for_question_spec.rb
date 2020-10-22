require "rails_helper"

feature 'user can add comment for question' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user adds comment to question', js: true do
    sign_in(user)
    visit question_path(question)

    within '.question-comments' do
      fill_in 'Comment', with: 'My comment'
      click_on 'add comment'
    end

    expect(page).to have_content 'My comment'
  end

  scenario 'Unauthenticated user tries add comment to question', js: true do
    visit question_path(question)

    within '.question-comments' do
      expect(page).to_not have_link 'add a comment'
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
        within '.question-comments' do
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
