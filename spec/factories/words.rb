# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :word do
    name "MyString"
    slug "MyString"
    publish false
    isbrand false
    keywords "MyString"
  end
end
