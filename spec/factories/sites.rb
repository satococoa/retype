# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :site do
    name "MyString"
    s3_access_key "MyString"
    s3_secret_key "MyString"
  end
end
