require 'spec_helper'
include CreateHelpers
# Capybara.default_wait_time = 5

describe "User registration" do
  before(:each) do
    create_ranks
    
    visit "/users/sign_up"      
    find_field('Username').value    
    fill_in "Username", 			       :with => "test_user"
    fill_in "Email", 			           :with => "test_user@example.com"
    fill_in "Password", 			       :with => "12345678"
    fill_in "Password confirmation", :with => "12345678"
    fill_in "Institution", 			     :with => "Test institution"
    fill_in "First name", 			     :with => "Test"
    fill_in "Last name", 			       :with => "User"
    
    find_button('Sign up').click
    # click_button "Sign up"    
  end
  
  it "should create a user and displays a confirmation link" do
    # puts page.body
    
    expect(page).to have_no_content("Welcome! You have signed up successfully.")
    expect(page).to have_content("A message with a confirmation link has been sent to your email address. Please open the link to activate your account")
  end
  
  subject(:last_user) {User.last}
  it "should confirm registration and logs in" do
    visit "/users/confirmation?confirmation_token=" + last_user.confirmation_token
    # puts page.body
    
    expect(page).to have_content("Your account was successfully confirmed. You are now signed in.")
    expect(page).to have_content("Logged in as " + last_user.username)
  end
  
  it "should still be possible log in after logout" do
    last_user.confirm!
    last_user.save!
    click_link "Login"            
    find_field('Username').value    
    fill_in "Username", :with => last_user.username
    fill_in "Password", :with => '12345678'
    find_button('Sign in').click
    
    expect(page).to have_no_content("Invalid username or password.")
  end
  
end

describe "User login_as" do

  before(:each) do
    @user = create_user_and_login
    create_ranks    
  end
  
  it "has a valid factory" do
    expect(@user).to be_valid    
  end

  it "should sign in as an existing user and displays the user's username" do
    visit root_path
    expect(page).to have_content("Logged in as " + @user.username)    
  end
  
  it "should show visualization if logged in" do
    visit "/visualization"  
    expect(page).to have_content("Community Visualization")
  end
  
  
  it "should redirect to home if sign out" do
    visit "/"
    
    expect(page).to have_content("Logged in as " + @user.username)
    expect(page).to have_no_content("Login")
    
    click_link "Logout"            
    # puts page.body
    expect(page).to have_content("Login")
    expect(page).to have_content("Signed out successfully.")
    
  end
  
  it "should show whether a user is logged in" do
    # puts "HERE: @user = " + @user.inspect
    visit "/visualization"
    expect(page).to have_content("Logged in as #{@user.username}")
    click_link "Logout"    
    visit "/visualization"
    # visit "/pages/overview"        
    # visit "/"        
    # puts page.body
    
    expect(page).to have_no_content("Logged in as #{@user.username}")
    expect(page).to have_content("You need to sign in or sign up before continuing.")
    # puts page.body
    
  end
  
  
end
  
describe "User not logged in" do
  before(:each) do
    create_ranks
  end  
  
  it "should not sign in if wrong credentials" do
    visit "/users/sign_in"
    find_field('Username').value
    fill_in "Username", :with => "wrong_user"
    fill_in "Password", :with => "bad password"
    find_button('Sign in').click
    # click_button "Sign in"
    # puts page.body
    
    expect(page).to have_content("Invalid username or password")
  end

  it "should redirect to sign in if not logged in" do
    visit "/visualization"
    # puts page.body
    
    expect(page).to have_content("Sign in")
  end

  # it "should not create a new user if validation failed"
  
  
end
