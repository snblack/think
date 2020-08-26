require "rails_helper"

feature 'any user can browse list of questions' do

  scenario 'browses questions' do
    create_list(:question, 3)

    visit root_path
    
    expect(page).to have_content 'List of questions'
    expect(page).to have_content 'MyString'
    expect(page).to have_content 'MyText'
  end

end
