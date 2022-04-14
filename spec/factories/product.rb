FactoryBot.define do
  factory :product do
    name { Faker::Lorem.sentence }
    qty { 1 }
  end
end