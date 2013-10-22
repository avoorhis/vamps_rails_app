require 'spec_helper'

describe "Visualisation" do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.confirm!
    login_as(@user, :scope => :user)
    # @projects = "SLM_NIH_Bv4v5"
    # @datasets = "1St_156_Marathon", "1St_85_DELANO"
  end
  
  it "gets taxon_strings by taxonomy ids" do
    ranks_to_use = ["domain", "phylum", "klass"]
    taxonomy_id_strings_upto_rank = {82=>[2, 3, 3], 96=>[2, 4, 32], 137=>[2, 3, 5]}
    
    taxon_strings_upto_rank = Visualisation.new.make_taxon_strings_by_t_id(ranks_to_use, taxonomy_id_strings_upto_rank)
    taxon_strings_upto_rank.should == {82=>["Bacteria", "Proteobacteria", "Gammaproteobacteria"], 96=>["Bacteria", "Actinobacteria", "class_NA"], 137=>["Bacteria", "Proteobacteria", "Alphaproteobacteria"]}
  end

  it "gets needed info from db" 
  # do
    # SELECT project, dataset, taxon_string, knt, sdc.classifier, frequency, dataset_count
    # sql = "SELECT project, dataset, taxonomy, knt, classifier, frequency, dataset_count 
           # FROM "
           
           
  # end
  

end