FactoryBot.define do
  factory :trip do
    title      { Faker::Team.name }
    start_date { Faker::Date.between(from: '2022-01-01', to: '2030-12-31') }
    end_date   { start_date }

    after(:build) do |trip|
      trip.image.attach(io: File.open('public/images/computer04_laugh.png'), filename: 'computer04_laugh.png')
    end
  end
end
