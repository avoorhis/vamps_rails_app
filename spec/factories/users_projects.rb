# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :users_project, :class => 'UsersProjects' do
    user_id 1
    project_id 1
  end
end
