require "rails_helper"

feature 'user can search question with parameters' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question) }
  given!(:comment) { create(:comment, commentable: question) }

  scenario 'search question in all' do
    sign_in(user)
    visit root_path

    fill_in 'Search', with: question.title
    select('All', from: 'where')

    click_on 'Search'

    expect(page).to have_content(question.title)
  end

  scenario 'search answer in all' do
    sign_in(user)
    visit root_path

    fill_in 'Search', with: answer.body
    select('All', from: 'where')

    click_on 'Search'

    expect(page).to have_content(answer.body)
  end

  scenario 'search comment in all' do
    sign_in(user)
    visit root_path

    fill_in 'Search', with: comment.body
    select('All', from: 'where')

    click_on 'Search'

    expect(page).to have_content(comment.body)
  end

  scenario 'search user in all' do
    sign_in(user)
    visit root_path

    fill_in 'Search', with: user.name
    select('All', from: 'where')

    click_on 'Search'

    expect(page).to have_content(user.name)
  end

  scenario 'search question in question' do
    sign_in(user)
    visit root_path

    fill_in 'Search', with: question.title
    select('Question', from: 'where')

    click_on 'Search'

    expect(page).to have_content(question.title)
  end

  scenario 'search answer in answer' do
    sign_in(user)
    visit root_path

    fill_in 'Search', with: answer.body
    select('Answer', from: 'where')

    click_on 'Search'

    expect(page).to have_content(answer.body)
  end

  scenario 'search comment in comment' do
    sign_in(user)
    visit root_path

    fill_in 'Search', with: comment.body
    select('Comment', from: 'where')

    click_on 'Search'

    expect(page).to have_content(comment.body)
  end

  scenario 'search user in user' do
    sign_in(user)
    visit root_path

    fill_in 'Search', with: user.name
    select('User', from: 'where')

    click_on 'Search'

    expect(page).to have_content(user.name)
  end


end
