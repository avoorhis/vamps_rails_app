# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  
  factory :taxon do |taxon|
    # before(:create) do |taxon|
    #   aa = FactoryGirl.build(:taxonomy)
    #   puts "UUU"
    #   puts aa.inspect
    # end
    
    sequence(:taxon){|n| "Bacteria#{n}" }
    taxon.rank_id       1
    # taxon.taxonomies   { Array.new(3) { FactoryGirl.build(:taxonomy) } }    
    
  end
end