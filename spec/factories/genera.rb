# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :genus do
    sequence(:genus){|n| "Acidovorax#{n}" }
    # taxon.taxonomies   { Array.new(3) { FactoryGirl.build(:taxonomy) } }    
  end
end

