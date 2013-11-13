require 'spec_helper'
include CreateHelpers

describe "Taxa" do
  
  let(:user)           {create_user_and_login}
  let(:taxonomies)     {create_taxonomies}
  let(:dat_counts_seq) {[{:dataset_id=>3, :sequence_id=>1, :seq_count=>2, :taxonomy_id=>96}, {:dataset_id=>3, :sequence_id=>4, :seq_count=>8, :taxonomy_id=>82}, {:dataset_id=>3, :sequence_id=>5, :seq_count=>3, :taxonomy_id=>137}, {:dataset_id=>4, :sequence_id=>1, :seq_count=>2, :taxonomy_id=>96}, {:dataset_id=>4, :sequence_id=>4, :seq_count=>4, :taxonomy_id=>82}]}
  let(:tax_hash_obj)   {TaxaCount.new}
  
  
  before(:each) do
    create_ranks_w_data
    
    @projects       = user.projects      
    @tax_hash       = tax_hash_obj.create(taxonomies, dat_counts_seq)
    
    visit "/visualization"      
  end
  
  it "creates correct counts per dataset" do
    expect(tax_hash_obj.taxa_count_per_d).to eq({2=>{3=>{3=>{16=>{18=>{129=>{129=>{4=>{:datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, 5=>{65=>{129=>{129=>{129=>{4=>{:datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>11, 4=>4}}, 4=>{6=>{5=>{52=>{76=>{129=>{4=>{:datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>13, 4=>6}}})
  end
  
  it "gives correct taxa per dataset counts" do
    a = tax_hash_obj.get_cnts_per_dataset_ids_by_tax_ids(@tax_hash, [2])
    expect(a).to eq({3=>13, 4=>6})
  
    a = tax_hash_obj.get_cnts_per_dataset_ids_by_tax_ids(@tax_hash, [2, 3])
    expect(a).to eq({3=>11, 4=>4})
  
    a = tax_hash_obj.get_cnts_per_dataset_ids_by_tax_ids(@tax_hash, [2, 3, 3, 16, 18, 129, 129, 4])
    expect(a).to eq({3=>8, 4=>4})
  end

  it "shows correct numbers on the tax_table page", :js=> true do
    # ActiveRecord::Base.logger = Logger.new(STDOUT) if defined?(ActiveRecord::Base)
    find(:css, 'label.project-select input', match: :first).click
    create_seq_info
    # puts page.body
    
    # class
    page.choose('tax_id_2')
    find_button('Submit').click
    
    expect(page).to have_content("Bacteria;Proteobacteria;Gammaproteobacteria")    
    expect(page).to have_content("Total count")    
    expect(page).to have_content("13")    
    
  end

  it "shows only one of each taxonomy on the tax_table page", :js=> true do 
    
    # ActiveRecord::Base.logger = Logger.new(STDOUT) if defined?(ActiveRecord::Base)
    find(:css, 'label.project-select input', match: :first).click
    create_seq_info
    find_button('Submit').click
    # puts page.body
    
    expect(page.all("td.td-text-left").count).to eql(2)
    
  end

end

class Hash
  def self.recursive
    new { |hash, key| hash[key] = recursive }
  end
end
