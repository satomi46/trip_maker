FactoryBot.define do
  factory :user do
    nickname              { Faker::Name.name }
    email                 { Faker::Internet.free_email }
    password              { Faker::Lorem.characters(min_alpha: 1, min_numeric: 1, number: 15) }
    password_confirmation { password }
  end
end
