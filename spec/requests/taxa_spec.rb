require 'spec_helper'
# require 'create_sequences_helper'
include TaxaCountHelper
include CreateHelpers

describe "Taxa" do
  before(:each) do
    create_ranks_w_data
    Taxonomy.delete_all
    
    @user = FactoryGirl.create(:user)
    @user.confirm!    
    login_as(@user, :scope => :user)

    @projects   = @user.projects
      
    @taxonomies = create_taxonomies
    @dat_counts_seq = [{:dataset_id=>3, :sequence_id=>1, :seq_count=>2, :taxonomy_id=>96}, {:dataset_id=>3, :sequence_id=>4, :seq_count=>8, :taxonomy_id=>82}, {:dataset_id=>3, :sequence_id=>5, :seq_count=>3, :taxonomy_id=>137}, {:dataset_id=>4, :sequence_id=>1, :seq_count=>2, :taxonomy_id=>96}, {:dataset_id=>4, :sequence_id=>4, :seq_count=>4, :taxonomy_id=>82}]
    
    @tax_hash_obj = TaxaCount.new
    @tax_hash     = @tax_hash_obj.create(@taxonomies, @dat_counts_seq)
    
    ranks_array = [{:rank => "NA", :rank_number => 10},
    {:rank => "class", :rank_number => 2},
    {:rank => "domain", :rank_number => 0},
    {:rank => "family", :rank_number => 4},
    {:rank => "genus", :rank_number => 5},
    {:rank => "order", :rank_number => 3},
    {:rank => "phylum", :rank_number => 1},
    {:rank => "species", :rank_number => 6},
    {:rank => "strain", :rank_number => 7}
    ]

    Rank.delete_all
    @ranks = Array.new
    ranks_array.each do |my_hash|
       @ranks.push(FactoryGirl.create(:rank, rank: my_hash[:rank], rank_number: my_hash[:rank_number]))       
    end

    visit "/visualization"      
  end
  
  # it "should show taxonomy" do
  #   puts "Ura1"
  #   # puts @taxa.inspect
  # end
  
  it "creates correct counts per dataset" do
    puts "\nSTART1: creates correct counts per dataset"
    
    @tax_hash_obj.taxa_count_per_d.should == {2=>{3=>{3=>{16=>{18=>{129=>{129=>{4=>{:datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, 5=>{65=>{129=>{129=>{129=>{4=>{:datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>11, 4=>4}}, 4=>{32=>{5=>{52=>{76=>{129=>{4=>{:datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>13, 4=>6}}}
  
  end
  
  it "gives correct taxa per dataset counts" do
    puts "\nSTART2: gives correct taxa per dataset counts"
    
    a = @tax_hash_obj.get_cnts_per_dataset_ids_by_tax_ids(@tax_hash, [2])
    a.should == {3=>13, 4=>6}
  
    a = @tax_hash_obj.get_cnts_per_dataset_ids_by_tax_ids(@tax_hash, [2, 3])
    a.should == {3=>11, 4=>4}
  
    a = @tax_hash_obj.get_cnts_per_dataset_ids_by_tax_ids(@tax_hash, [2, 3, 3, 16, 18, 129, 129, 4])
    a.should == {3=>8, 4=>4}
    
  end

  it "shows correct numbers on the tax_table page", :js=> true do
    puts "\nSTART3: shows correct numbers on the tax_table page"
    
    # ActiveRecord::Base.logger = Logger.new(STDOUT) if defined?(ActiveRecord::Base)
    
    # puts "-" * 5
    
    project      = Project.first
    # puts "\nURA0: "
    project_name = project.project
    dataset      = project.datasets

    Sequence.delete_all
    ActiveRecord::Base.establish_connection
    sql = "INSERT IGNORE INTO sequences (id, sequence_comp, created_at, updated_at) VALUES (1, compress('AGCCTTTGACATCCTAGGACGACTTCTGGAGACAGATTTCTTCCCTTCGGGGACCTAGTGAC'), NOW(), NOW()), (2, compress('TGGTCTTGACATAGTAAGAACTTTCCAGAGATGGATTGGTGCCTTCGGGAACTTACAT'), NOW(), NOW()), (3, compress('TGGCCTTGACATGCAGAGAACTTTCCAGAGATGGATTGGTGCCTTCGGGAACTCTGAC'), NOW(), NOW()), (4, compress('AGGTCTTGACATCCCAGTGACCGTCCTAGAGATAGGATTTTTCTTCGGAACACAGAC'), NOW(), NOW()), (5, compress('TACTCTTGACATCCAGAGAACTTAGCAGAGATGCTTTGGTGCCTTCGGTCTGAGAC'), NOW(), NOW())" 
    ActiveRecord::Base.connection.execute(sql)
    
    @sequence_uniq_info = Array.new
    @sequence_uniq_info << FactoryGirl.create(:sequence_uniq_info, :sequence_id=>1, :taxonomy_id=>96)
    @sequence_uniq_info << FactoryGirl.create(:sequence_uniq_info, :sequence_id=>4, :taxonomy_id=>82)
    @sequence_uniq_info << FactoryGirl.create(:sequence_uniq_info, :sequence_id=>5, :taxonomy_id=>137)
    
    @sequence_uniq_info = SequenceUniqInfo.all
        
    SequencePdrInfo.create(dataset_id: 3, sequence_id: 1, seq_count: 2)
    SequencePdrInfo.create(dataset_id: 3, sequence_id: 4, seq_count: 8)
    SequencePdrInfo.create(dataset_id: 3, sequence_id: 5, seq_count: 3)
    SequencePdrInfo.create(dataset_id: 4, sequence_id: 1, seq_count: 2)
    SequencePdrInfo.create(dataset_id: 4, sequence_id: 4, seq_count: 4)

    @sequence_pdr_info = SequencePdrInfo.all
    # class
    find(:xpath, "//*[@id=\"basic_taxonomy_selector\"]/label[10]").click
    check(project_name)
    find_button('Submit').click
    # puts page.body
    
    page.should have_content("Total count")    
    
  end

end

class Hash
  def self.recursive
    new { |hash, key| hash[key] = recursive }
  end
end
