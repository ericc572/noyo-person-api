FactoryBot.define do
  factory :person do
    age { rand(1..80) }
    first_name { "Fake#{age}" }
    last_name { "Person" }
    email { "fake_person#{age}@gmail.com" }
  end
end