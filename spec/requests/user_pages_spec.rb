require 'spec_helper'

describe User do
  # before(:each) do
  #   # @user = Factory.build(:user)
  #   user = FactoryGirl.build(:user)
  #   user.password = "123456"
  #   user.save
  #   # post :login, {:email => user.email, :password => "123456"}
  #   
  # end
  
  it "has a valid factory" do
    # FactoryGirl.create(:user).should be_valid
    FactoryGirl.build(:user).should be_valid
    # User.create.should be_valid
  end
  

  # it "should create a new instance of a user given valid attributes" do
  #   User.create!(@user.attributes)
  # end
end



# require 'factory_girl_rails'
# FactoryGirl.find_definitions

# describe :user do
#     # @user = FactoryGirl.create(:user) 
#     # subject(:user)
#     it "has a valid factory" do
#       FactoryGirl.create(:user).should be_valid
#     end
# end
# user = FactoryGirl.create(:user)
# def sign_in_as_a_valid_user
#   # @user ||= FactoryGirl.create :user
#   
#   # post_via_redirect user_session_path, 'user[email]' => @user.email, 'user[password]' => @user.password
#   post_via_redirect user_session_path, 'user[email]' => user.email, 'user[password]' => user.password
#   
# end
# 
# describe "GET /users/sign_up" do
#   it "test access to things, works with a signed in user" do
#     sign_in_as_a_valid_user
#     get things_path
#     response.status.should be(200)
#   end
# end

# describe "GET /things" do
#   it "test access to things, does not work without a signed in user" do
#     get things_path
#     response.status.should be(302) # redirect to sign in page
#   end
# end