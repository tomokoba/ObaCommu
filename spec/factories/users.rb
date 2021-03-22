FactoryBot.define do
  factory :user do
    name { "tomoko" }
    sequence(:email) { |n| "tomoko#{n}@example.com"}
    password { "password" }
    confirmed_at { Date.today }
  end
end