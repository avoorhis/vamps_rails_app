# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :phylum do
    sequence(:phylum){|n| "Bacteroidetes#{n}" }
  end
end
