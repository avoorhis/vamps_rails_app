# spec/factories/user_factory.rb

FactoryGirl.define do
  
  factory :confirmed_user, :parent => :user do |f|
    f.after_create { |user| user.confirm! }
  end
  
  factory :user do |user|
    user.username               "test_user"
    user.email                  "user@example.com"
    user.password               "password"
    user.password_confirmation  "password"
    user.institution            "Test institution"						
    user.first_name						  "Test"
    user.last_name						  "User"
  end
end

