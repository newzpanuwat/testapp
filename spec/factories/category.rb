FactoryBot.define do
  factory :category do
    name { Faker::Lorem.sentence(word_count: 3) }
  end
end