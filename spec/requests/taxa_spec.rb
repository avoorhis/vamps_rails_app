require 'spec_helper'
require 'create_ranks_w_data_helper'
include TaxaCountHelper

describe "Taxa" do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.confirm!    
    login_as(@user, :scope => :user)

    # @projects   = @user.projects      
    @taxonomies = Array.new
    @taxonomies << FactoryGirl.create(:taxonomy, id: 82, domain_id: 2, phylum_id: 3, klass_id: 3, order_id: 16, family_id: 18, genus_id: 129, species_id: 129, strain_id: 4)
    @taxonomies << FactoryGirl.create(:taxonomy, id: 96, domain_id: 2, phylum_id: 4, klass_id: 32, order_id: 5, family_id: 52, genus_id: 76, species_id: 129, strain_id: 4)
    @taxonomies << FactoryGirl.create(:taxonomy, id: 137, domain_id: 2, phylum_id: 3, klass_id: 5, order_id: 65, family_id: 129, genus_id: 129, species_id: 129, strain_id: 4)
    # @taxonomies = Array.new(3) { FactoryGirl.create(:taxonomy) } 

    visit "/visualization"      
  end
  
  it "should show taxonomy" do
    puts "Ura1"
    # puts @taxa.inspect
  end
  
  it "should give correct taxa per dataset counts" do
    puts "Ura2"
    puts @taxonomies.inspect
            
    dat_counts_seq = [{:dataset_id=>3, :sequence_id=>1001, :seq_count=>2, :taxonomy_id=>96}, {:dataset_id=>3, :sequence_id=>1004, :seq_count=>8, :taxonomy_id=>82}, {:dataset_id=>3, :sequence_id=>1007, :seq_count=>3, :taxonomy_id=>137}, {:dataset_id=>4, :sequence_id=>1001, :seq_count=>2, :taxonomy_id=>96}, {:dataset_id=>4, :sequence_id=>1004, :seq_count=>4, :taxonomy_id=>82}]
    puts "dat_counts_seq = " + dat_counts_seq.inspect
    
    tax_hash_obj = TaxaCount.new
    tax_hash     = tax_hash_obj.create(@taxonomies, tax_hash, dat_counts_seq)
    puts "\nRES: tax_hash = " + tax_hash.inspect
    # tax_hash_temp[:datasets_ids] = {3=>8, 4=>4}
    # 
    # tax_hash_obj.get_tax_hash_by_tax_ids(tax_hash, [2]) #{3=>13, 4=>6}
    # tax_hash_obj.get_tax_hash_by_tax_ids(tax_hash, [2, 3]) #{3=>11, 4=>4}
    # puts "[2, 3, 3, 16, 18, 129, 1, 4]"
    # puts "HERE:"
    # tax_hash_obj.get_tax_hash_by_tax_ids(tax_hash, [2, 3, 3, 16, 18, 129, 129, 4]) #=>{3=>8, 4=>4}
    
  end

  
  # it "should have projects and datasets" do
  #   puts page.body
  #   # puts "URA"
  #   # puts FactoryGirl.attributes_for(:taxon)
  #   # puts FactoryGirl.attributes_for(:rank)
  #   # puts FactoryGirl.attributes_for(:user)
  #   page.should have_content("SLM_NIH_v")
  #   
  #   page.html.should include('_Stockton')
  # end
  # 
  # it "should check all underlying dataset checkboxes if its project was chosen" 
  # 
  # it "should keep datasets checked after we hide the list"
end
