FactoryGirl.define do
  factory :page do
    name    { Faker::Lorem.words(2).join(' ').capitalize }
    title   { Faker::Lorem.word }
    content { (Faker::Lorem.words(7).join(' ') + '.').capitalize }
  end
end
