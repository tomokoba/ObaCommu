FactoryBot.define do
  factory :post do
    title { Faker::Lorem.characters(number: 5) }
    caption { Faker::Lorem.characters(number: 20) }
    user

    after(:build) do |post|
      post.photos << FactoryBot.build(:photo)
    end
  end
  factory :post_nophoto do
    title { Faker::Lorem.characters(number: 5) }
    caption { Faker::Lorem.characters(number: 20) }
    user
  end
end
