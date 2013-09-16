require 'spec_helper'

describe "User registration" do
  before(:each) do
    @ranks    = FactoryGirl.create(:rank)
    @taxa     = Array.new(3) { FactoryGirl.build(:taxon) } 
    
    visit "/users/sign_up"      
    fill_in "Username", 			       :with => "test_user"
    fill_in "Email", 			           :with => "test_user@example.com"
    fill_in "Password", 			       :with => "12345678"
    fill_in "Password confirmation", :with => "12345678"
    fill_in "Institution", 			     :with => "Test institution"
    fill_in "First name", 			     :with => "Test"
    fill_in "Last name", 			       :with => "User"
    
    click_button "Sign up"    
  end
  
  it "should create a user and displays a confirmation link" do
    page.should have_no_content("Welcome! You have signed up successfully.")
    page.should have_content("A message with a confirmation link has been sent to your email address. Please open the link to activate your account")
  end
  
  it "should confirm registration and logs in" do
    user = User.last
    visit "/users/confirmation?confirmation_token=" + user.confirmation_token
    # puts page.body
    
    page.should have_content("Your account was successfully confirmed. You are now signed in.")
    page.should have_content("Logged in as " + user.username)
  end
  
  it "should still be possible log in after logout" do
    user = User.last
    user.confirm!
    user.save!
    click_link "Login"            
    fill_in "Username", :with => user.username
    fill_in "Password", :with => '12345678'
    click_button "Sign in"
    # puts user.inspect
    
    page.should have_no_content("Invalid username or password.")
  end
  
end

describe "User login_as" do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.confirm!
    login_as(@user, :scope => :user)
    @ranks    = FactoryGirl.create(:rank)
    @taxa     = Array.new(3) { FactoryGirl.build(:taxon) } 
    
  end
  
  it "has a valid factory" do
    @user.should be_valid    
  end

  it "should sign in as an existing user and displays the user's username" do
    visit root_path
    page.should have_content("Logged in as " + @user.username)
    
  end
  
  it "should show visualization if logged in" do
    visit "/visualization"  
    page.should have_content("Community Visualization")
  end
  
  
  it "should redirect to home if sign out" do
    visit "/"
    
    page.should have_content("Logged in as " + @user.username)
    page.should have_no_content("Login")
    
    click_link "Logout"            
    # puts page.body
    page.should have_content("Login")
    page.should have_content("Signed out successfully.")
    
  end
  
  
end
  
describe "User not logged in" do
  before(:each) do
    @ranks    = FactoryGirl.create(:rank)
    @taxa     = Array.new(3) { FactoryGirl.build(:taxon) } 
  end  
  
  it "should not sign in if wrong credentials" do
    visit "/users/sign_in"
    fill_in "Username", :with => "wrong_user"
    fill_in "Password", :with => "bad password"
    click_button "Sign in"
    # puts page.body
    
    page.should have_content("Invalid username or password")
  end

  it "should redirect to sign in if not logged in" do
    visit "/visualization"
    # puts page.body
    
    page.should have_content("Sign in")
  end

  it "should not create a new user if validation failed"
  
end
