FactoryGirl.define do
  factory :page do
    name    { Faker::Lorem.words(2).join(' ').capitalize }
    content { (Faker::Lorem.words(7).join(' ') + '.').capitalize }

    factory :titled_page do
      title { Faker::Lorem.word }
    end
  end
end
