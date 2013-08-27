# spec/factories/user_factory.rb

FactoryGirl.define do
  factory :user do |user|
    user.user                   "Test User"
    user.email                  "user@example.com"
    user.password               "password"
    user.password_confirmation  "password"
    user.passwd                 "password"
  end
end

# FactoryGirl.define do
#   factory :user do |f|
#     f.user     "test_user"
#     f.email    "username@example.com"
#     f.password "12345678"
#     # f.encrypted_password "$2a$04$.lWs6yadJu/Ya67xi.W1F.fd6sWLGkzc/59.lgTi0sA7"
#     f.password_confirmation "12345678" 
#     f.passwd "12345678"
# # todo: why password vs. passwd? devise???
#   end
# end

# FactoryGirl.define do
#   factory :user do
#     user     "test_user"
#     email    "username@example.com"
#     password "foobar"
#   end
# end
