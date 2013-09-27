# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :domain do
    sequence(:domain){|n| "Archaea#{n}" }
  end
end
