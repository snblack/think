FactoryBot.define do
  factory :answer do
    body { "MyString" }

    trait :invalid do
      body { nil }
    end
  end
end
