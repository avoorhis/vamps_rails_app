require 'spec_helper'

describe "Visualisation" do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.confirm!
    login_as(@user, :scope => :user)
    @projects = "SLM_NIH_Bv4v5"
    @datasets = "1St_156_Marathon", "1St_85_DELANO"
  end

  it "does get needed info from db" do
    # SELECT project, dataset, taxon_string, knt, sdc.classifier, frequency, dataset_count
    sql = "SELECT project, dataset, taxonomy, knt, classifier, frequency, dataset_count 
           FROM "
           
           
  end
  

end