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
  end
end
