# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :dropbox_file do
    modified "2013-11-14 23:44:59"
    size "MyString"
    revision 1
    path "MyString"
    mime_type "MyString"
    book_id 1
  end
end
