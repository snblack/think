FactoryBot.define do
  factory :reward do
    name { "The best man" }
    before :create do |reward|
      reward.file.attach fixture_file_upload("#{Rails.root}/spec/images/reward.png")
    end
  end
end
