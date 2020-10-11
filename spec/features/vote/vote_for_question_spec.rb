require "rails_helper"

feature 'user can vote for question/answer' do
  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, user: user2) }

  describe 'Not Author' do

    context 'for page show' do
      background do
        sign_in(user)

        visit question_path(question)
      end

      scenario 'Authenticate user can vote for question', js: true do
        click_on 'Up'

        within '.question' do
          expect(page).to have_content '1'
        end
      end


      scenario 'User can vote only one times for question', js: true do
        click_on 'Up'

        within '.question' do
          expect(page).to have_content '1'
        end

        expect(page).to_not have_link 'Up'
      end

      scenario 'User can cancel vote and vote again for question', js: true do
        click_on 'Up'

        within '.question' do
          expect(page).to have_content '1'
        end

        click_on 'Down'

        within '.question' do
          expect(page).to have_content '-1'
        end

        click_on 'Up'

        within '.question' do
          expect(page).to have_content '1'
        end
      end
    end

    context 'for page index' do
      background do
        sign_in(user)

        visit questions_path
      end

      scenario 'Authenticate user can vote for question', js: true do
        click_on 'Up'

        within '.questions' do
          expect(page).to have_content '1'
        end
      end


      scenario 'User can vote only one times for question', js: true do
        click_on 'Up'

        within '.questions' do
          expect(page).to have_content '1'
        end

        expect(page).to_not have_link 'Up'

        within '.questions' do
          expect(page).to have_content '1'
        end
      end

      scenario 'User can cancel vote and vote again for question', js: true do
        click_on 'Up'

        within '.questions' do
          expect(page).to have_content '1'
        end

        click_on 'Down'

        within '.questions' do
          expect(page).to have_content '-1'
        end

        click_on 'Up'

        within '.questions' do
          expect(page).to have_content '1'
        end
      end
    end
  end

  describe 'Author' do
    given!(:question) { create(:question, user: user) }

    context 'for page show' do
      background do
        sign_in(user)

        visit question_path(question)
      end

      scenario 'User can not vote for self question', js: true do
        click_on 'Up'

        within '.questions' do
          expect(page).to have_content '0'
        end
      end
    end

    context 'for page index' do
      background do
        sign_in(user)

        visit questions_path
      end

      scenario 'User can not vote for self question', js: true do
        click_on 'Up'
  
        within '.questions' do
          expect(page).to have_content '0'
        end
      end

    end

  end
end
