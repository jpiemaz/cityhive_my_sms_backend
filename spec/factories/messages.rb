FactoryBot.define do
  factory :message do
    text { "Test message" }
    phone_number { "+15555550123" }
    association :user
  end
end
