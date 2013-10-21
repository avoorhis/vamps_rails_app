require 'spec_helper'
require 'create_ranks_w_data_helper'
require 'create_sequences_helper'
include TaxaCountHelper

describe "Taxa" do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.confirm!    
    login_as(@user, :scope => :user)

    @projects   = @user.projects      
    @taxonomies = Array.new(3) { FactoryGirl.create(:taxonomy) } 
       
    puts "Ura2"
    puts @taxonomies.inspect
            
    visit "/visualization"      
  end
  
  it "should show taxonomy" do
    puts "Ura1"
    # puts @taxa.inspect
  end
  
  it "should give correct taxa per dataset counts" do
    # puts "@projects = " + @projects.inspect
    dataset_ids = [3,4]
    dat_counts_seq = [{:dataset_id=>3, :sequence_id=>1001, :seq_count=>2, :taxonomy_id=>1}, {:dataset_id=>3, :sequence_id=>1002, :seq_count=>103, :taxonomy_id=>2}, {:dataset_id=>3, :sequence_id=>1004, :seq_count=>8, :taxonomy_id=>3}, {:dataset_id=>3, :sequence_id=>1005, :seq_count=>203, :taxonomy_id=>2}, {:dataset_id=>3, :sequence_id=>1007, :seq_count=>3, :taxonomy_id=>137}, {:dataset_id=>4, :sequence_id=>1001, :seq_count=>2, :taxonomy_id=>1}, {:dataset_id=>4, :sequence_id=>1002, :seq_count=>13, :taxonomy_id=>2}, {:dataset_id=>4, :sequence_id=>1004, :seq_count=>4, :taxonomy_id=>3}, {:dataset_id=>4, :sequence_id=>1005, :seq_count=>20, :taxonomy_id=>2}]
    
    
    tax_hash_obj = TaxaCount.new
    
    # tax_hash = {2=>{3=>{3=>{16=>{18=>{129=>{129=>{4=>{:datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, 5=>{65=>{129=>{129=>{129=>{4=>{:datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>11, 4=>4}}, 4=>{32=>{5=>{52=>{76=>{129=>{4=>{:datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>13, 4=>6}}}



    # dat_counts_seq = create_dat_seq_cnts(my_pdrs)  
    # 
    # taxonomies = get_taxonomies(dat_counts_seq)
    
    
    
    tax_hash_obj = TaxaCount.new
    tax_hash     = tax_hash_obj.create(@taxonomies, tax_hash, dat_counts_seq)
    puts "\nRES: tax_hash = " + tax_hash.inspect
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
