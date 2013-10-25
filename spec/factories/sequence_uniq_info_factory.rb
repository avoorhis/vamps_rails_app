# spec/factories/sequence_uniq_info.rb

FactoryGirl.define do
  # before(:create) do |sequence_uniq_info|
  # end
  
  factory :sequence_uniq_info do |sequence_uniq_info|    
    sequence_uniq_info.sequence_id   1
    sequence_uniq_info.taxonomy_id   96
    sequence_uniq_info.gast_distance 0.0
    sequence_uniq_info.refssu_id     0
    sequence_uniq_info.refssu_count  4
    sequence_uniq_info.rank_id       4
    sequence_uniq_info.refhvr_ids    "v6_AO871"
    sequence_uniq_info.created_at    Time.now
    sequence_uniq_info.updated_at    Time.now
  end
end
