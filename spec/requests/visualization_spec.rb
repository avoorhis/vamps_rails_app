require 'spec_helper'
include CreateHelpers

describe "Projects and Datasets list" do
  let(:ranks) {FactoryGirl.create(:rank)}
  let(:projects) {user.projects}
  
  before(:each) do
    Rank.delete_all
    Project.delete_all
    user = create_user_and_login  
    visit "/visualization"      
  end
  
  it "should have projects and datasets" do
    # puts page.body
    expect(page).to have_content("SLM_NIH_v")
    expect(page.html).to include('_Stockton')
  end

  it "should have ranks" do
    # puts page.body
    expect(page).to have_content("Domain")
    # 
    # page.html.should include('_Stockton')
  end

  it "should check all underlying dataset checkboxes if its project was chosen", :js=> true do
    expect(page.body).to have_xpath("//img[@alt='plus' and @src = 'assets/tree_plus.gif']")
    
    check(Project.first.project)
    
    expect(page.body).to have_xpath("//img[@alt='minus' and @src = 'assets/tree_minus.gif']")
    
  end
  
  it "should keep datasets checked after we hide the list"
  
  it "should show a message if nothing is choosen" do
    find_button('Submit').click
    
    expect(page).to have_content("Choose some data!")    
    expect(page).to have_content("Community Visualization")    
  end
  
  
end
