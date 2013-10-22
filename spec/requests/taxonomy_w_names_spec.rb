require 'spec_helper'
require 'create_ranks_w_data_helper'
# include TaxaCountHelper

describe "TaxonomyWNames" do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.confirm!    
    login_as(@user, :scope => :user)
    
    FactoryGirl.create(:klass, id: 32, klass: "class_NA")
    
    @taxonomies = Array.new
    @taxonomies << FactoryGirl.create(:taxonomy, id: 82, domain_id: 2, phylum_id: 3, klass_id: 3, order_id: 16, family_id: 18, genus_id: 129, species_id: 129, strain_id: 4)
    @taxonomies << FactoryGirl.create(:taxonomy, id: 96, domain_id: 2, phylum_id: 4, klass_id: 32, order_id: 5, family_id: 52, genus_id: 76, species_id: 129, strain_id: 4)
    @taxonomies << FactoryGirl.create(:taxonomy, id: 137, domain_id: 2, phylum_id: 3, klass_id: 5, order_id: 65, family_id: 129, genus_id: 129, species_id: 129, strain_id: 4)
    
    @taxon_strings_upto_rank_obj = TaxonomyWNames.new

    visit "/visualization"      
  end
  
  
  it "gives correct taxon_strings_upto_rank" do
    taxon_strings_upto_rank = @taxon_strings_upto_rank_obj.create(2, @taxonomies)
    puts "URA test: taxon_strings_upto_rank = " + taxon_strings_upto_rank.inspect

    taxon_strings_upto_rank.should == {82=>["Bacteria", "Proteobacteria", "Gammaproteobacteria"], 96=>["Bacteria", "Actinobacteria", "class_NA"], 137=>["Bacteria", "Proteobacteria", "Alphaproteobacteria"]}
    
  end
  

end
