require 'spec_helper'
include CreateHelpers

describe "Taxa" do
  before(:each) do
    create_ranks_w_data
    
    user            = create_user_and_login
    @projects       = user.projects      
    @taxonomies     = create_taxonomies
    @dat_counts_seq = [{:dataset_id=>3, :sequence_id=>1, :seq_count=>2, :taxonomy_id=>96}, {:dataset_id=>3, :sequence_id=>4, :seq_count=>8, :taxonomy_id=>82}, {:dataset_id=>3, :sequence_id=>5, :seq_count=>3, :taxonomy_id=>137}, {:dataset_id=>4, :sequence_id=>1, :seq_count=>2, :taxonomy_id=>96}, {:dataset_id=>4, :sequence_id=>4, :seq_count=>4, :taxonomy_id=>82}]
    
    @tax_hash_obj   = TaxaCount.new
    @tax_hash       = @tax_hash_obj.create(@taxonomies, @dat_counts_seq)
    
    visit "/visualization"      
  end
  
  # it "should show taxonomy" do
  #   puts "Ura1"
  #   # puts @taxa.inspect
  # end
  
  it "creates correct counts per dataset" do
    @tax_hash_obj.taxa_count_per_d.should == {2=>{3=>{3=>{16=>{18=>{129=>{129=>{4=>{:datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, 5=>{65=>{129=>{129=>{129=>{4=>{:datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>11, 4=>4}}, 4=>{32=>{5=>{52=>{76=>{129=>{4=>{:datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>13, 4=>6}}}
  end
  
  it "gives correct taxa per dataset counts" do
    a = @tax_hash_obj.get_cnts_per_dataset_ids_by_tax_ids(@tax_hash, [2])
    a.should == {3=>13, 4=>6}
  
    a = @tax_hash_obj.get_cnts_per_dataset_ids_by_tax_ids(@tax_hash, [2, 3])
    a.should == {3=>11, 4=>4}
  
    a = @tax_hash_obj.get_cnts_per_dataset_ids_by_tax_ids(@tax_hash, [2, 3, 3, 16, 18, 129, 129, 4])
    a.should == {3=>8, 4=>4}
  end

  # it "shows redirect ot the tax_table page", :js=> true do
  #   check(Project.first.project)
  #   create_seq_info
  #   find_button('Submit').click
  #   page.should have_content("Total count")    
  # end

  it "shows correct numbers on the tax_table page", :js=> true do
    # ActiveRecord::Base.logger = Logger.new(STDOUT) if defined?(ActiveRecord::Base)
    
    check(Project.first.project)
    create_seq_info
    
    # class
    page.choose('tax_id_2')
    find_button('Submit').click
    puts page.body
    
    page.should have_content("Bacteria;Proteobacteria;Gammaproteobacteria")    
    page.should have_content("Total count")    
    page.should have_content("13")    
    
  end

  it "shows only one of each taxonomy on the tax_table page", :js=> true do 
    check(Project.first.project)
    create_seq_info
    find_button('Submit').click
    puts page.body
    
    # page.should have_css("td.td-text-left", :count => 2)
    page.all("td.td-text-left").count.should eql(2)
    
  end

end

class Hash
  def self.recursive
    new { |hash, key| hash[key] = recursive }
  end
end
