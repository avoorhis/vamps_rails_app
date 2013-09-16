require 'spec_helper'


describe "Projects and Datasets list" do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.confirm!    
    login_as(@user, :scope => :user)

    @projects = @user.projects
    @ranks    = FactoryGirl.create(:rank)
    @taxa     = Array.new(3) { FactoryGirl.build(:taxon) } 
    
    visit "/visualization"      
  end
  
  it "should have projects and datasets" do
    puts page.body
    page.should have_content("SLM_NIH_v3")
    
    page.html.should include('7_Stockton')
  end

  it "should check all underlying dataset checkboxes if its project was chosen" 
  
  it "should keep datasets checked after we hide the list"
end
