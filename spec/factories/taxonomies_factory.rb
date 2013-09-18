# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :taxonomy do |taxonomy|
    taxonomy.superkingdom_id 2
    taxonomy.created_at Time.now
    taxonomy.updated_at Time.now    
  end
end

# taxonomy.phylum_id 11
# taxonomy.class_id  37
# taxonomy.orderx_id 15
# taxonomy.family_id 31
# taxonomy.genus_id 24
# taxonomy.species_id 7
# taxonomy.strain_id 8
