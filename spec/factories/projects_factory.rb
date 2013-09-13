# spec/factories/user_factory.rb


FactoryGirl.define do
  factory :project do |project|
    
    # before(:create) do |project|
    #   user = FactoryGirl.create(:user)
    #   project.user_id = user.id
    # end
    sequence(:project){|n| "SLM_NIH_v#{n}" }
		project.title               "WWTP_Influents"
		project.project_description "Analysis microbial communities found in sewage influent samples collected from a variety of WWTPs."
		sequence(:rev_project_name){|n| "#{n}v_HIN_MLS" }
		project.funding             "1"
  end
end

