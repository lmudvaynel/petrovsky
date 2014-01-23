FactoryGirl.define do
  factory :page do
    name 'Name'
    content 'Content'

    factory :titled_page do
      title 'Title'
    end
  end
end
