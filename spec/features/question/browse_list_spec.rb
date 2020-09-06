require "rails_helper"

feature 'any user can browse list of questions' do

  scenario 'browses questions' do
    @questions = create_list(:question, 3)

    visit root_path

    expect(page).to have_content 'List of questions'

    @questions.each do |q|
      expect(page).to have_content q.title
    end
  end

end
