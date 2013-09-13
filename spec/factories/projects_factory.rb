# spec/factories/user_factory.rb


FactoryGirl.define do
  factory :project do |project|
    
    sequence(:project){|n| "SLM_NIH_v#{n}" }
		project.title               "WWTP_Influents"
		project.project_description "Analysis microbial communities found in sewage influent samples collected from a variety of WWTPs."
		sequence(:rev_project_name){|n| "#{n}v_HIN_MLS" }
		project.funding             "1"
		project.user_id             1
    # project.datasets           { Array.new(3) { FactoryGirl.build(:dataset) } }
    
  end
end

