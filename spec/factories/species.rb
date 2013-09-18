# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :species do
    sequence(:species){|n| "abyssi#{n}" }
  end
end
