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
  end
end
