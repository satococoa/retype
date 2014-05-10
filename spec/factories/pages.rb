# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :page do
    site nil
    title "MyString"
    template "MyString"
    path "MyString"
    data "MyText"
  end
end
