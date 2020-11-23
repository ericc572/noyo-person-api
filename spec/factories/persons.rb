FactoryBot.define do
  factory :person do
    first_name { Faker::Lorem.word }
    last_name { Faker::Lorem.word }
    email { "fake_person@gmail.com" }
    age { Faker::Number.number(10) }
  end
end