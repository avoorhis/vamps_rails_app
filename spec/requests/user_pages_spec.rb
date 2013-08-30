require 'spec_helper'

# after(:each) do
#   Warden.test_reset! 
# end

describe 'should be able to log in' do
  before do
    user = FactoryGirl.create(:user)
    user.confirm!
    puts user.inspect    
    puts user.password
    
    visit root_path
    click_on 'Login'
    

    fill_in 'Username', with: user.username
    fill_in 'Password', with: "12345678"
    click_on 'Sign in'
    puts page.body
    
  end
  subject { page }
  
  it { 
      should have_link 'Log out' 
      page.should have_no_content("Invalid login or password")
    }
end
# 
# 
# describe "User registration" do
#   before(:each) do
#     visit "/users/sign_up"      
#     fill_in "Username",              :with => "test_user"
#     fill_in "Email",                 :with => "test_user@example.com"
#     fill_in "Password",              :with => "12345678"
#     fill_in "Password confirmation", :with => "12345678"
#     fill_in "Institution",           :with => "Test institution"
#     fill_in "First name",            :with => "Test"
#     fill_in "Last name",             :with => "User"
#     
#     click_button "Sign up"    
#   end
#   
#   it "create a user and displays a confirmation link" do
#     # expect {
#     #   visit "/users/sign_up"      
#     #   fill_in "Username",              :with => "test_user"
#     #   fill_in "Email",                 :with => "test_user@example.com"
#     #   fill_in "Password",              :with => "12345678"
#     #   fill_in "Password confirmation", :with => "12345678"
#     #   fill_in "Institution",           :with => "Test institution"
#     #   fill_in "First name",            :with => "Test"
#     #   fill_in "Last name",             :with => "User"
#     #   
#     #   click_button "Sign up"    
#     # }.to change(User, :count).by(1)
#     
#     # puts User.last.inspect
#     # 
#     # u_new = User.last
#     # u_new.username    = "test_user"
#     # u_new.password    = "12345678"
#     # u_new.institution = "Test institution"
#     # u_new.first_name  = "Test"
#     # u_new.last_name   = "User"
#     # u_new.save!
#     # puts "=" * 10
#     # 
#     # 
#     # puts "=" * 10
#     # puts User.last.inspect
#     # puts User.last.username
#     # puts User.last.email
#     # puts User.last.institution
#     # puts User.last.first_name
#     # puts User.last.last_name
#     # puts "=" * 10
#     # puts User.last.username
#     # User.first.confirm!
#     # print User.first.confirmed_at
#     # puts "=" * 10
#     # print ActionMailer::Base.deliveries
#     # puts "=" * 10
#     
#     # puts page.body
#     page.should have_no_content("Welcome! You have signed up successfully.")
#     page.should have_content("A message with a confirmation link has been sent to your email address. Please open the link to activate your account")
#   end
#   
#   it "confirm registration and logs in" do
#     user = User.last
#     # puts user.inspect
#     visit "/users/confirmation?confirmation_token=" + user.confirmation_token
#     # puts page.body
#     page.should have_content("Your account was successfully confirmed. You are now signed in.")
#     page.should have_content("Logged in as " + user.username)
#   end
#   
#   it "should still be possible log in after logout" do
#     user = User.last
#     user.confirm!
#     user.save!
#     
#     puts user.inspect
#     puts user.valid_password?('12345678')
#     puts "-" * 8
#     ppp = user.password
#     puts ppp
#     puts user.valid_password?(ppp)
#     puts "-" * 8
#     # user.password = "12345678"
#     # user.save!
#     # 
#     # puts user.password
#     # puts user.valid_password?(user.password)
#     # 
#     # user.confirm!
#     # user.save!
#     # # visit "/users/confirmation?confirmation_token=" + user.confirmation_token
#     # # puts page.body
#     # 
#     # # click_link "Logout"    
#     # # puts page.body
#     # # 
#     # # page.should have_content("Signed out successfully.")
#     click_link "Login"            
#     # puts user.inspect
#     fill_in "Username", :with => user.username
#     fill_in "Password", :with => '12345678'
#     click_button "Sign in"
#     # # puts user.inspect
#     puts page.body
#     
#     page.should have_no_content("Invalid login or password.")
#     # # 
#   end
#   
# end
# 
# describe "User login" do
# 
#   it "no signs in if wrong credentials" do
#     visit "/users/sign_in"
#     fill_in "Username", :with => "test_user"
#     fill_in "Password", :with => "12345678"
#     click_button "Sign in"
#     
#     page.should have_content("Invalid login or password.")
#   end
# 
#   it "sign in as an existing user and displays the user's username" do
#     user = FactoryGirl.create(:user)
#     user.confirm!
#     login_as(user, :scope => :user)
# 
#     visit root_path
#     # puts page.body
#     page.should have_content("Logged in as " + user.username)
#     
#   end
#   
#   it "has a valid factory" do
#     user = FactoryGirl.create(:user)
#     user.should be_valid    
#   end
# 
#   it "redirect to sign in if not logged in" do
#     visit "/visualization"
#     page.should have_content("Sign in")
#   end
# 
#   it "show visualization if logged in" do
#     user = FactoryGirl.create(:user)
#     user.confirm!
#     login_as(user, :scope => :user)
#     
#     visit "/visualization"
#     page.should have_content("Community Visualization")
#   end
# 
#   # 
#   it "not create a new user if validation failed"
#   it "redirect to home if sign out"
# end
