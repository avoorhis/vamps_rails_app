# spec/factories/user_factory.rb

FactoryGirl.define do
  factory :project do |project|
    
    # before(:create) do |project|
    #   user = FactoryGirl.create(:user)
    #   project.user_id = user.id
    # end
    project.project             "SLM_NIH_" + Random.rand(99).to_s()
		project.title               "WWTP_Influents"
		project.project_description "Analysis microbial communities found in sewage influent samples collected from a variety of WWTPs."
		project.rev_project_name    ""
		project.funding             "1"
  end
end

