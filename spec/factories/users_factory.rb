# spec/factories/user_factory.rb

def make_projects()
  pr_arr =  Array.new(30) { FactoryGirl.build(:project) } 
  puts pr_arr.inspect
  # pr_arr2 = Array.new {pr_arr}
  # puts pr_arr2.uniq.inspect
  return pr_arr

end


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
    user.projects               { Array.new(3) { FactoryGirl.build(:project) } }
    
  end
end

