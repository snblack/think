FactoryBot.define do
  factory :comment do
    user
    body { "MyComment" }
  end

  trait :invalid do
    user
    body { "" }
  end
end
