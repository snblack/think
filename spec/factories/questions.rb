FactoryBot.define do
  sequence :title do |n|
    "#{n}MyString"
  end

  factory :question do
    user
    title
    body { "MyText" }

    trait :invalid do
      title { nil }
    end

    trait :with_files do
      before :create do |question|
        question.files.attach fixture_file_upload("#{Rails.root}/spec/rails_helper.rb")
        question.files.attach fixture_file_upload("#{Rails.root}/spec/spec_helper.rb")
      end
    end

    trait :with_links do
      user
      title
      body { "MyText" }
      link
    end
  end
end
