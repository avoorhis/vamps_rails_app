# spec/factories/dataset_factory.rb

FactoryGirl.define do
  factory :dataset do |dataset|
    
    before(:create) do |dataset|
    #   project = FactoryGirl.create(:project)
      env_sample_source = FactoryGirl.create(:env_sample_source)
    #   dataset.project_id = project.id
      dataset.env_sample_source_id = env_sample_source.id
    end
    
    sequence(:dataset){|n| "#{n}_Stockton" }
		dataset.dataset_description "121_Stockton"
  end
end
