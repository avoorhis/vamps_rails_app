# spec/factories/sequence_pdr_info.rb

FactoryGirl.define do
  # before(:create) do |sequence_pdr_info|
  # end
  
  factory :sequence_pdr_info do |sequence_pdr_info|
    # id, dataset_id, sequence_id, seq_count, classifier, created_at, updated_at
    sequence_pdr_info.dataset_id    3
    sequence_pdr_info.sequence_id   1
    sequence_pdr_info.seq_count     2
    sequence_pdr_info.created_at    Time.now
    sequence_pdr_info.updated_at    Time.now
  end
end
