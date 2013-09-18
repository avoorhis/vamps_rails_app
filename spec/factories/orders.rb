# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    sequence(:order){|n| "Bacteroidales#{n}" }
  end
end
