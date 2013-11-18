# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :local_file do
    book_pdf "MyString"
    book_djvu "MyString"
    djvu_state "MyString"
  end
end
