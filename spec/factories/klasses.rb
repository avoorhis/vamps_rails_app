# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :klass do
    sequence(:klass){|n| "Alphaproteobacteria#{n}" }
    # taxon.taxonomies   { Array.new(3) { FactoryGirl.build(:taxonomy) } }    
  end
end
