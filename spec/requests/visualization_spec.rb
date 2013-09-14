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
    # page.should have_xpath('//*[@id="3"]/li[2]/label/text()')
    check('SLM_NIH_v3--pj-id')
    puts find_field('SLM_NIH_v3--ds-ids_').value
    # click('SLM_NIH_v3--pj-id')
    page.should have_content("7_Stockton")    
  end

  it "should check all underlying dataset checkboxes if its project was chosen" 
  
  it "should keep datasets checked after we hide the list"
end