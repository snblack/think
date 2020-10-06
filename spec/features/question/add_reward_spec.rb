require "rails_helper"

feature 'user can add reward to question' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'User adds reward when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    within ".nested-fields-reward" do
      fill_in 'Reward name', with: 'The best man'
      attach_file 'File', "#{Rails.root}/spec/images/reward.png"
    end

    click_on 'Ask'

    expect(page).to have_content 'The best man'
    expect(page).to have_css("img[src*='reward.png']")
  end

  scenario 'User adds reward with invalid name when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    within ".nested-fields-reward" do
      fill_in 'Reward name', with: ''
      attach_file 'File', "#{Rails.root}/spec/images/reward.png"
    end

    click_on 'Ask'

    expect(page).to_not have_css("img[src*='reward.png']")
  end
end
