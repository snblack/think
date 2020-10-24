require "rails_helper"

feature 'user can create answer for question', %q{
  The user, while on the question page,
   can write an answer to a question (i.e. a new
   the answer should be right on the question page,
   without going to another page)
} do

  given(:user) { create(:user) }
  given(:question) {create(:question, user: user)}

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Authenticate user create answer', js: true do
      fill_in 'Body', with: "text text text"
      click_on 'Post your answer'

      expect(page).to have_content 'text text text'
    end

    scenario 'asks a answer with attached file', js: true do
      within '.new-answer' do
        fill_in 'Body', with: "text text text"
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      end

      click_on 'Post your answer'
      expect(page).to have_link "rails_helper.rb"
      expect(page).to have_link "spec_helper.rb"
    end
  end

  describe 'Unauthenticated user' do
    scenario 'Unauthenticated user tries to answer' do
      visit question_path(question)

      within '.new-answer' do
        fill_in 'Body', with: "text text text"
        click_on 'Post your answer'
      end

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end

    scenario 'Authenticate user create answer with error', js: true do
      sign_in(user)
      question = create(:question)
      visit question_path(question)

      click_on 'Post your answer'

      expect(page).to have_content "Body can't be blank"
    end

    context "mulitple sessions" do
      given(:user) { create(:user) }
      given(:question) {create(:question, user: user)}

      scenario "question appears on another user's page", js:true do
        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)
        end

        Capybara.using_session('guest') do
          visit question_path(question)
        end

        Capybara.using_session('user') do
          fill_in 'Body', with: 'answer test'
          click_on 'Post your answer'
          expect(page).to have_content 'answer test'
        end

        Capybara.using_session('guest') do
          expect(page).to have_content 'answer test'
          within '.answers' do
            expect(page).to_not have_link 'Delete'
            expect(page).to_not have_link 'Edit'
          end

        end
      end
    end
  end
end
