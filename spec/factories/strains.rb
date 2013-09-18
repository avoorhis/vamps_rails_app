# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :strain do
    sequence(:strain){|n| "DSM 5456#{n}" }
  end
end
