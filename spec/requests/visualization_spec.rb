require 'spec_helper'
require 'create_ranks_w_data_helper'

describe "Projects and Datasets list" do
  before(:each) do
    Rank.delete_all
    User.delete_all
    Project.delete_all
    @user = FactoryGirl.create(:user)
    @user.confirm!    
    login_as(@user, :scope => :user)

    @projects = @user.projects
    @ranks    = FactoryGirl.create(:rank)
    # @taxa     = Array.new(3) { FactoryGirl.build(:taxon) } 
            
    visit "/visualization"      
  end
  
  it "should have projects and datasets" do
    # puts page.body
    page.should have_content("SLM_NIH_v")
    
    page.html.should include('_Stockton')
  end

  it "should have ranks" do
    puts page.body
    page.should have_content("Domain")
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
    page.body.should have_xpath("//img[@alt='plus' and @src = 'assets/tree_plus.gif']")
    
    check(project_name)
    # page.execute_script("$('body').empty()")
    
    # <img alt="minus" src="assets/tree_minus.gif">
    # assert page.has_xpath("//image[@alt='minus' and @src = 'assets/tree_minus.gif']")
    # page.should have_selector(:xpath, "//image[@alt='minus' and @src = 'assets/tree_minus.gif']")
    page.body.should have_xpath("//img[@alt='minus' and @src = 'assets/tree_minus.gif']")
    
  end
  
  it "should keep datasets checked after we hide the list"
  
  it "should show a message if nothing is choosen" do
    find_button('Submit').click
    page.should have_content("Choose some data!")    
    page.should have_content("Community Visualization")    
  end
  
  
end
