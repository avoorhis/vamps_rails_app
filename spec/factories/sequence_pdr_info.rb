# spec/factories/sequence_pdr_info.rb

FactoryGirl.define do
  factory :sequence_pdr_info do |sequence_pdr_info|
    # id, sequence_comp, created_at, updated_at, , , ,     
    sequence(:sequence_pdr_info){|n| "#{n}_Stockton" }
		sequence_pdr_info.dataset_description "121_Stockton"
		sequence_pdr_info.project_id          1
  end
end
