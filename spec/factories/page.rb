FactoryGirl.define do
  factory :page do
    slug :slug
    content 'Content'

    factory :named_page do
      name 'Name'
      title 'Title'
    end
  end
end
