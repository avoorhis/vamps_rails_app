# spec/factories/user_factory.rb

FactoryGirl.define do
  
  factory :confirmed_user, :parent => :user do |f|
    f.after_create { |user| user.confirm! }
  end
  # password_length = 8
  # password      = Devise.friendly_token.first(password_length)
  
  factory :user do |user|
    user.username               "test_user"
    user.email                  "user@example.com"
    user.password               "12345678"
    user.password_confirmation  "12345678"
    user.institution            "Test institution"						
    user.first_name						  "Test"
    user.last_name						  "User"
    user.projects               { Array.new(3) { FactoryGirl.create(:project) } }    
  end
end

