# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :species do
    sequence(:species){|n| "abyssi#{n}" }
    # taxon.taxonomies   { Array.new(3) { FactoryGirl.build(:taxonomy) } }    
  end
end

