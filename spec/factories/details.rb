FactoryBot.define do
  factory :detail do
    title      { Faker::Team.name }
    note       { Faker::Lorem.sentence }
    address    { Faker::Lorem.sentence }
    time       { Faker::Date.between(from: '2022-01-01', to: '2030-12-31') }
    time_note  { Faker::Lorem.sentence }
    importance { Faker::Number.between(from: 1, to: 5) }
    url        { Faker::Internet.url }
    association :trip
  end
end
