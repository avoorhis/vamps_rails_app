# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  
  factory :taxon do |taxon|
    # before(:create) do |taxon|
    #   ranks = []
    #   (0..12).each do |n|
    #     ranks.push(FactoryGirl.create(:rank, rank_id: n + 1, rank_number: n))
    #   # taxon.rank_id = rank.id
    #   end
    # end
  
    sequence(:taxon){|n| "Bacteria#{n}" }
    taxon.rank_id       1
  end
end