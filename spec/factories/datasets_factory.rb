# spec/factories/dataset_factory.rb

FactoryGirl.define do
  factory :dataset do |dataset|
    
    before(:create) do |dataset|
      env_sample_source = FactoryGirl.create(:env_sample_source)
      dataset.env_sample_source_id = env_sample_source.id
    end
    
    sequence(:dataset){|n| "#{n}_Stockton" }
		dataset.dataset_description "121_Stockton"
		dataset.project_id          1
  end
end
