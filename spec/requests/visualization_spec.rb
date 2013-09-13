require 'spec_helper'


describe "Projects and Datasets list" do
  before(:each) do
    @projects = FactoryGirl.create(:user).projects
    # puts "@projects = "
    # puts @projects.inspect
    #   @datasets = Array.new
    @projects.each do |project|
      puts "project = "
      puts project.datasets.inspect
    #   puts "project.datasets.inspect = "
    #   puts project.datasets.inspect
    #   
    #   @datasets.push(project.datasets)
    end
    # @datasets = FactoryGirl.create(:dataset)
    # @dataset = FactoryGirl.create(:dataset)
    # puts "@dataset = "
    # puts @dataset.inspect
    visit "/visualization"      
  end
  
  it "should check all underlying dataset checkboxes if its project was chosen" do
    puts page.body
    # check('A Checkbox')
    
  end
  it "should keep datasets checked after we hide the list"
end