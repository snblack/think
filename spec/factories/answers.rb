FactoryBot.define do
  sequence :body do |n|
    "#{n}String"
  end

  factory :answer do
    user
    body

    trait :invalid do
      body { nil }
    end

    trait :with_files do
      before :create do |answer|
        answer.files.attach fixture_file_upload("#{Rails.root}/spec/rails_helper.rb")
        answer.files.attach fixture_file_upload("#{Rails.root}/spec/spec_helper.rb")
      end
    end

    trait :with_links do
      before :create do |question|
        question.links.new(name: 'google', url: 'https://www.google.com/')
        question.links.new(name: 'vk', url: 'https://www.vk.com/')
      end
    end
  end
end
