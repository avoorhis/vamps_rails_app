require 'spec_helper'


describe "Projects and Datasets list" do
  before(:each) do
    # @project = FactoryGirl.create(:project)
    @dataset = FactoryGirl.create(:dataset)
    visit "/visualization"      
  end
  
  it "should check all underlying dataset checkboxes if its project was chosen" do
    puts page.body
    # check('A Checkbox')
    
  end
  it "should keep datasets checked after we hide the list"
end