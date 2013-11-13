require 'spec_helper'
include CreateHelpers

describe "Projects and Datasets list" do
  before(:each) do
    Rank.delete_all
    Project.delete_all
    user      = create_user_and_login  
    @projects = user.projects
    @ranks    = FactoryGirl.create(:rank)
            
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
    project_name = Project.first.project
    # puts "URA: #{project_name}"
    # <img alt="plus" src="assets/tree_plus.gif">
    # assert page.has_xpath("//image[@alt='plus' and @src = 'assets/tree_plus.gif']")
    # find(:xpath, "//image[@alt='plus' and @src = 'assets/tree_plus.gif']").value
    # page.should have_selector(:xpath, "//image[@alt='plus' and @src = 'assets/tree_plus.gif']")
    expect(page.body).to have_xpath("//img[@alt='plus' and @src = 'assets/tree_plus.gif']")
    
    check(project_name)
    # page.execute_script("$('body').empty()")
    
    # <img alt="minus" src="assets/tree_minus.gif">
    # assert page.has_xpath("//image[@alt='minus' and @src = 'assets/tree_minus.gif']")
    # page.should have_selector(:xpath, "//image[@alt='minus' and @src = 'assets/tree_minus.gif']")
    expect(page.body).to have_xpath("//img[@alt='minus' and @src = 'assets/tree_minus.gif']")
    
  end
  
  it "should keep datasets checked after we hide the list"
  
  it "should show a message if nothing is choosen" do
    find_button('Submit').click
    expect(page).to have_content("Choose some data!")    
    expect(page).to have_content("Community Visualization")    
  end
  
  
end
