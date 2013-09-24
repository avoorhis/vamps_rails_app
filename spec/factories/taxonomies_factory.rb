# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
    factory :taxonomy do |t|
      sequence(:superkingdom_id){|n| n}
      sequence(:phylum_id){|n| n}
      sequence(:klass_id ){|n| n}
      sequence(:order_id){|n| n}
      sequence(:family_id){|n| n}
      sequence(:genus_id){|n| n}
      sequence(:species_id){|n| n}
      sequence(:strain_id){|n| n}
      t.created_at Time.now
    end
end
