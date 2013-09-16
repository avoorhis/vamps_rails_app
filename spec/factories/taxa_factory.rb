# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  
  factory :taxon do |taxon|
    before(:create) do |taxon|
      rank = FactoryGirl.create(:rank)
      taxon.rank_id = rank.id
    end
  
    sequence(:taxon){|n| "Bacteria#{n}" }
    taxon.rank_id       1
  end
end