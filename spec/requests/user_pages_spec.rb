require 'spec_helper'

describe "User login" do

  it "no signs in if wrong credentials" do
    visit "/users/sign_in"
    fill_in "User", :with => "test_user"
    fill_in "Password", :with => "12345678"
    click_button "Sign in"
    
    page.should have_content("Invalid login or password.")
  end

  it "create a user and displays the user's username after successful login" do
    expect {
      visit "/users/sign_up"      
      fill_in "User", :with => "test_user"
      fill_in "Email", :with => "test_user@example.com"
      fill_in "Password", :with => "12345678"
      fill_in "Password confirmation", :with => "12345678"
      fill_in "Institution", :with => "Test institution"
      fill_in "First name", :with => "Test"
      fill_in "Last name", :with => "User"
      
      click_button "Sign up"    
    }.to change(User, :count).by(1)
    puts page.body
    page.should have_content("Welcome! You have signed up successfully.")
    
  end
  
  it "sign in as an existing user and displays the user's username" do
    user = FactoryGirl.create(:user)
    user.confirm!
    login_as(user, :scope => :user)
    
    visit root_path
    # puts page.body
    page.should have_content("Logged is as " + user.user)
    
  end
  it "has a valid factory" do
    FactoryGirl.build(:user).should be_valid
  end
  
  it "redirect to sign in if not logged in"
  it "not create a new user if validation failed"
  it "redirect to home if sing out"
end
