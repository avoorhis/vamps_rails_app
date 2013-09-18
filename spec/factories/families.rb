# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :family do
    sequence(:family){|n| "Acidimicrobiaceae#{n}" }
    # taxon.taxonomies   { Array.new(3) { FactoryGirl.build(:taxonomy) } }    
  end
end
