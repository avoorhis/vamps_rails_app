# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :superkingdom do
    sequence(:superkingdom){|n| "Archaea#{n}" }
  end
end
