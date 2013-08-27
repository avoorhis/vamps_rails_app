require 'spec_helper'

# describe "Users" do
#   describe "GET /users/sign_up" do
#     it "create users" do
#       User.create!(user: "test_user", password: "12345678", email: "test_user@example.com")
#       get new_user_session_path
#       response.body.should include("Welcome! You have signed up successfully.")
#       response.body.should include("Logged is as test_user")      
#     end
#   end
# end


describe "User login" do
  # before do
  #   visit "/users/sign_in"
  #   fill_in "User", :with => "test_user"
  #   fill_in "Password", :with => "12345678"
  #   click_button "Sign in"
  # end

  it "no signs in if wrong credentials" do
    visit "/users/sign_in"
    fill_in "User", :with => "test_user"
    fill_in "Password", :with => "12345678"
    click_button "Sign in"
    
    page.should have_content("Invalid login or password.")
  end

  it "create a user and displays the user's username after successful login" do
    # click_button "Sign in"
    # page.find("#menu_agents").click
    expect {
      visit "/users/sign_up"      
      # click_link("Sign up")
      fill_in "User", :with => "test_user"
      fill_in "Email", :with => "test_user@example.com"
      fill_in "Password", :with => "12345678"
      fill_in "Password confirmation", :with => "12345678"
      click_button "Sign up"
    
    }.to change(User, :count).by(1)
    page.should have_content("Welcome! You have signed up successfully.")
    
  end
  
  it "sign in as an existing user and displays the user's username" do
    # click_button "Sign in"
    # page.find("#menu_agents").click
    # FactoryGirl.create(:user, :user => "test_user", :password => "12345678", :password_confirmation => "12345678")
    # user = FactoryGirl.create(:user, :user => "test_user", :password => "12345678", :password_confirmation => "12345678", :email => "user@example.com")
    # user = User.create!(:user => "test_user", :password => "12345678", :password_confirmation => "12345678", :email => "user@example.com")
    user = FactoryGirl.create(:user)
    # user = User.find_by_email(user.email)
    
    puts "HERE"
    puts user.password
    # user.valid_password?(user.password)
    login_as(user, :scope => :user)
    
    visit root_path
    # page.should have_no_content("Welcome! You have signed up successfully.")
    # fill_in "User",     :with => user.user
    # fill_in "Password", :with => user.password
    # click_button "Sign in"

    # post "/users/sign_in"
    puts page.body
    page.should have_content("Logged is as Test User")
    
  end
  it "has a valid factory" do
    # FactoryGirl.create(:user).should be_valid
    FactoryGirl.build(:user).should be_valid
  end
  
  it "redirect to sign in if not logged in"

end


# describe User do
#   # before(:each) do
#   #   # @user = Factory.build(:user)
#   #   @user ||= FactoryGirl.build :user
#   #   # user = FactoryGirl.build(:user)
#   #   @user.user                   = "test_user"
#   #   @user.email                  = "test_user@example.com"
#   #   @user.password               = "12345678"
#   #   @user.password_confirmation  = "12345678"
#   #   # @user.passwd                 = "12345678"
#   #   @user.save
#   #   
#   #   # post :login, {:email => user.email, :password => "123456"}    
#   # end
#   
#   before do
#     visit "/visualization/bar_charts"    
#     # click_button "Sign In"    
#   end
#   
#   # 
#   # 
#   # it "should create a new instance of a user given valid attributes" do
#   #   print @user.attributes
#   # end
#   
#   it "blocks unauthenticated access" do
# 
#    user = User.create(email: "lol@mail.com", password: "123456")
#    request.stub(:authenticate!)
#    # puts response.body
#    # and_throw(:warden, {:scope => :user})
# 
# 
#     page.should have_content("Signed in successfully.")
# 
#   end
#   
#   
# end
# 
# 
# 
# # require 'factory_girl_rails'
# # FactoryGirl.find_definitions
# 
# # describe :user do
# #     # @user = FactoryGirl.create(:user) 
# #     # subject(:user)
# #     it "has a valid factory" do
# #       FactoryGirl.create(:user).should be_valid
# #     end
# # end
# # user = FactoryGirl.create(:user)
# # def sign_in_as_a_valid_user
# #   # @user ||= FactoryGirl.create :user
# #   
# #   # post_via_redirect user_session_path, 'user[email]' => @user.email, 'user[password]' => @user.password
# #   post_via_redirect user_session_path, 'user[email]' => user.email, 'user[password]' => user.password
# #   
# # end
# # 
# # describe "GET /users/sign_up" do
# #   it "test access to things, works with a signed in user" do
# #     sign_in_as_a_valid_user
# #     get things_path
# #     response.status.should be(200)
# #   end
# # end
# 
# # describe "GET /things" do
# #   it "test access to things, does not work without a signed in user" do
# #     get things_path
# #     response.status.should be(302) # redirect to sign in page
# #   end
# # end