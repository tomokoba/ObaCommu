FactoryBot.define do
  factory :photo do
    image_id { 'test' }
    image { StringIO.new('test') }
  end
end
