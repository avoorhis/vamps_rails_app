# spec/factories/user_factory.rb

FactoryGirl.define do
  factory :project do |project|
    
    before(:create) do |project|
      user = FactoryGirl.create(:user)
      project.user_id = user.id
    end
    
    project.project             "SLM_NIH_Bv4v5"
		project.title               "WWTP_Influents"
		project.project_description "Analysis microbial communities found in sewage influent samples collected from a variety of WWTPs."
		project.rev_project_name    "5v4vB_HIN_MLS"
		project.funding             "1"
  end
end

