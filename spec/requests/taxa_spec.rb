require 'spec_helper'
include CreateHelpers

describe "Taxa" do
  before(:each) do
    create_ranks_w_data
    
    user            = create_user_and_login
    @projects       = user.projects      
    taxonomies     = create_taxonomies
    @dat_counts_seq = [{:dataset_id=>3, :sequence_id=>1, :seq_count=>2, :taxonomy_id=>96}, {:dataset_id=>3, :sequence_id=>4, :seq_count=>8, :taxonomy_id=>82}, {:dataset_id=>3, :sequence_id=>5, :seq_count=>3, :taxonomy_id=>137}, {:dataset_id=>4, :sequence_id=>1, :seq_count=>2, :taxonomy_id=>96}, {:dataset_id=>4, :sequence_id=>4, :seq_count=>4, :taxonomy_id=>82}]
    
    @tax_hash_obj   = TaxaCount.new
    @tax_hash       = @tax_hash_obj.create(taxonomies, @dat_counts_seq)
    
    visit "/visualization"      
  end
  
  # it "should show taxonomy" do
  #   puts "Ura1"
  #   # puts @taxa.inspect
  # end
  
  it "creates correct counts per dataset" do
    @tax_hash_obj.taxa_count_per_d.should == {2=>{3=>{3=>{16=>{18=>{129=>{129=>{4=>{:datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, 5=>{65=>{129=>{129=>{129=>{4=>{:datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>11, 4=>4}}, 4=>{6=>{5=>{52=>{76=>{129=>{4=>{:datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>13, 4=>6}}}
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
    puts "lane 47"
    # ActiveRecord::Base.logger = Logger.new(STDOUT) if defined?(ActiveRecord::Base)
    # within ".project-select" do
    # check("label", :match => :first)
    # end
    # 
    # within page.find(".project-select") do
    #   within page.find("label", :text => /\ASLM_NIH_*/) do
    #     page.should have_xpath('td[3]', text: @today)
    #   end
    # end
    
    # //*[@id="SLM_NIH_Bv4v5--pj-id"]
    #     <input id="SLM_NIH_Bv4v5--pj-id" name="project_ids[]" onclick="open_datasets('6','SLM_NIH_Bv4v5')" type="checkbox" value="6">
    # puts find("label", {:text => /\ASLM_NIH_*/, :match => first})
    # aa = page.all('label', :text => /\ASLM_NIH_*/)
    # find("a.edit-link:first").click
    # find(:css, "label.project-select:first-child input").check
    # find(:xpath, '//[@label="project-select"]/..').fill_in "Name:", :with => name
    # puts page.all('label.project-select', :text => /\ASLM_NIH_*/).inspect
    # parent_element_h1 = value.css("h1").first.parent
     puts page.find(:css, 'label.project-select input', match: :first).inspect
    # puts all("label.project-select input").inspect
    puts "-"  * 10
    # puts all("label.project-select").inspect
    # all("label.project-select input:nth-child(1)")[0].check
    # aa = all("label.project-select input")[0]
    find(:css, 'label.project-select input', match: :first).click
    # puts "+"  * 10
    # puts aa.inspect
    # check(aa)
    # puts find(:css, "label.project-select:nth-child(1)").inspect
    # page.find("label.project-select").find(".result:nth-child(1)").text
    # page.find("#latest-results tbody").find(".result:nth-child(1)").text
    # find(:css, "input label.project-select:first-child").check
    # find(:css, "label.project-select input:nth-child(1)").check
    
    # all(:css, "label.project-select input")[0].check
    # input[type="checkbox"]
    # aa = first("input[type='checkbox']")
    # puts aa.inspect
    # puts "+" * 8
    # # puts aa[0].inspect
    # check(aa)
    # , :match => first)
    
    # check(Project.first.project)
    create_seq_info
    puts page.body
    
    # class
    page.choose('tax_id_2')
    find_button('Submit').click
    
    page.should have_content("Bacteria;Proteobacteria;Gammaproteobacteria")    
    page.should have_content("Total count")    
    page.should have_content("13")    
    
  end

  it "shows only one of each taxonomy on the tax_table page", :js=> true do 
    puts "lane 65"
    puts "Project.first.project = " + Project.first.project
    
    puts "@projects.first.project = " +@projects.first.project
    
    # ActiveRecord::Base.logger = Logger.new(STDOUT) if defined?(ActiveRecord::Base)
    # find("#pickem_option_ids_10").check
    # check(Project.first.project)
    find(:css, 'label.project-select input', match: :first).click
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
