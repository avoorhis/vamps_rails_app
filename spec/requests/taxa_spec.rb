require 'spec_helper'
require 'create_ranks_w_data_helper.rb'
include TaxaCountHelper

describe "Taxa" do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.confirm!    
    login_as(@user, :scope => :user)

    @projects   = @user.projects      
    @taxonomies = Array.new(3) { FactoryGirl.build(:taxonomy) } 
       
    puts "Ura2"
    puts @taxonomies.inspect
            
    visit "/visualization"      
  end
  
  it "should show taxonomy" do
    puts "Ura1"
    # puts @taxa.inspect
  end
  
  it "should give correct taxa per dataset counts" do
    puts "@projects = " + @projects.inspect
    seq = 
    sequence = FactoryGirl.create(:sequence)
    puts "sequence = " + sequence.inspect
    
    dataset_ids = []
    @projects.each do |p|
      puts "p.datasets = " + p.datasets.inspect
      p.datasets.each do |d|
        puts "d = " + d.inspect
      end
    end
    puts "SequencePdrInfo = " + SequencePdrInfo.last.inspect
    my_pdrs = SequencePdrInfo.where(dataset_id: [1, 2])
    puts "my_pdrs = " + my_pdrs.inspect
    # dat_counts_seq = create_dat_seq_cnts(my_pdrs)  
    # 
    # taxonomies = get_taxonomies(dat_counts_seq)
    # tax_hash_obj = TaxaCount.new
    # tax_hash     = tax_hash_obj.create(@taxonomies, tax_hash, dat_counts_seq)
    # puts "\nRES: tax_hash = " + tax_hash.inspect
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
