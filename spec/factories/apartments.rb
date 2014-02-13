# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :apartment do
    image "MyString"
    dx 1
    dy 1
    number 1
    floor_number 1
    sold_out false
  end
end
