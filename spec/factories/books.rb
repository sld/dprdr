# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :book do
    name "MyString"
    good_name "MyString"
    page 1
    last_access "2013-10-19 07:07:27"
    bookfile "MyString"
    bookcover "MyString"
    user_id 1
    pages_count 1
  end
end
