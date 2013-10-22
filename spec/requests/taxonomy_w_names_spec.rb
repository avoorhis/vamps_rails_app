require 'spec_helper'
require 'create_ranks_w_data_helper'
# include TaxaCountHelper

describe "TaxonomyWNames" do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.confirm!    
    login_as(@user, :scope => :user)
    
    @taxonomies = Array.new
    @taxonomies << FactoryGirl.create(:taxonomy, id: 82, domain_id: 2, phylum_id: 3, klass_id: 3, order_id: 16, family_id: 18, genus_id: 129, species_id: 129, strain_id: 4)
    @taxonomies << FactoryGirl.create(:taxonomy, id: 96, domain_id: 2, phylum_id: 4, klass_id: 32, order_id: 5, family_id: 52, genus_id: 76, species_id: 129, strain_id: 4)
    @taxonomies << FactoryGirl.create(:taxonomy, id: 137, domain_id: 2, phylum_id: 3, klass_id: 5, order_id: 65, family_id: 129, genus_id: 129, species_id: 129, strain_id: 4)
    
    
    
    @taxon_strings_upto_rank_obj = TaxonomyWNames.new
    @rank_number = 2
    # ranks_to_use                  = @taxon_strings_upto_rank_obj.send get_ranks_to_use(rank_number) 
    # rank_id_names                 = ranks_to_use.map{|rank_name| rank_name + "_id" }
    # puts "MMM2: rank_id_names = " + rank_id_names.inspect
    # @taxon_strings_upto_rank_obj.instance_eval{ @current_account }.should eql ... # check the value of the instance variable
       # @controller.send(:current_account)
    # taxonomy_id_strings_upto_rank = make_taxonomy_id_strings_upto_rank(rank_id_names)
    # @taxon_strings_by_t_id        = make_taxon_strings_by_t_id(ranks_to_use, taxonomy_id_strings_upto_rank)
    # 
    # taxon_strings_upto_rank      = @taxon_strings_upto_rank_obj.create(rank_number, @taxonomies)
    # puts "YYY: taxon_strings_upto_rank = " + taxon_strings_upto_rank.inspect
    

    visit "/visualization"      
  end
  
  
  it "gives correct taxon_strings_upto_rank" do
    
    rank_id_names = ["domain_id", "phylum_id", "klass_id"]
    taxon_strings_upto_rank      = @taxon_strings_upto_rank_obj.create(2, @taxonomies)
    
    # taxonomy_id_strings_upto_rank = @taxon_strings_upto_rank_obj.instance_eval{make_taxonomy_id_strings_upto_rank(rank_id_names)}
    # @taxon_strings_upto_rank_obj.instance_eval{ get_ranks_to_use(rank_number) }   # invoke the private method
    taxonomy_id_strings_upto_rank = {82=>[2, 3, 3], 96=>[2, 4, 32], 137=>[2, 3, 5]}

    taxon_strings_upto_rank.should == {82=>["Bacteria", "Proteobacteria", "Gammaproteobacteria"], 96=>["Bacteria", "Actinobacteria", "class_NA"], 137=>["Bacteria", "Proteobacteria", "Alphaproteobacteria"]}

    taxon_strings_upto_rank.should equal({82=>["Bacteria", "Proteobacteria", "Gammaproteobacteria"], 96=>["Bacteria", "Actinobacteria", "class_NA"], 137=>["Bacteria", "Proteobacteria", "Alphaproteobacteria"]})

    taxon_strings_upto_rank.should eql({82=>["Bacteria", "Proteobacteria", "Gammaproteobacteria"], 96=>["Bacteria", "Actinobacteria", "class_NA"], 137=>["Bacteria", "Proteobacteria", "Alphaproteobacteria"]})
    
  end
  

end
