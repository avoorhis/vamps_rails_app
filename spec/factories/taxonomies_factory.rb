# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  
  factory :taxonomy do |taxonomy|
    taxonomy.superkingdom_id 1
    taxonomy.phylum_id 2
    taxonomy.class_id  3
    taxonomy.orderx_id 4
    taxonomy.family_id 5
    taxonomy.genus_id 6
    taxonomy.species_id 7
    taxonomy.strain_id 8
    taxonomy.created_at Time.now
    taxonomy.updated_at Time.now
    # 
    # sequence(:taxon){|n| "Bacteria#{n}" }
    # taxon.rank_id       1
    # taxon.taxonomy   { Array.new(3) { FactoryGirl.build(:taxonomy) } }    
    
  end
end