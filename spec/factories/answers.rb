FactoryBot.define do
  factory :answer do
    user
    body { "MyString" }

    trait :invalid do
      body { nil }
    end
  end
end
