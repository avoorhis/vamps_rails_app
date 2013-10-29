require 'spec_helper'
require 'create_ranks_w_data_helper.rb'
# require 'create_sequences_helper'
include TaxaCountHelper

describe "Taxa" do
  before(:each) do
    Taxonomy.delete_all
    
    @user = FactoryGirl.create(:user)
    @user.confirm!    
    login_as(@user, :scope => :user)

    @projects   = @user.projects
      
    # TODO: DRY: the same in taxonomy_w_names_spec.rb
    @taxonomies = Array.new
    @taxonomies << FactoryGirl.create(:taxonomy, id: 82, domain_id: 2, phylum_id: 3, klass_id: 3, order_id: 16, family_id: 18, genus_id: 129, species_id: 129, strain_id: 4)
    @taxonomies << FactoryGirl.create(:taxonomy, id: 96, domain_id: 2, phylum_id: 4, klass_id: 32, order_id: 5, family_id: 52, genus_id: 76, species_id: 129, strain_id: 4)
    @taxonomies << FactoryGirl.create(:taxonomy, id: 137, domain_id: 2, phylum_id: 3, klass_id: 5, order_id: 65, family_id: 129, genus_id: 129, species_id: 129, strain_id: 4)
    # @taxonomies = Array.new(3) { FactoryGirl.create(:taxonomy) } 

    @dat_counts_seq = [{:dataset_id=>3, :sequence_id=>1, :seq_count=>2, :taxonomy_id=>96}, {:dataset_id=>3, :sequence_id=>4, :seq_count=>8, :taxonomy_id=>82}, {:dataset_id=>3, :sequence_id=>5, :seq_count=>3, :taxonomy_id=>137}, {:dataset_id=>4, :sequence_id=>1, :seq_count=>2, :taxonomy_id=>96}, {:dataset_id=>4, :sequence_id=>4, :seq_count=>4, :taxonomy_id=>82}]
    # puts "@dat_counts_seq = " + @dat_counts_seq.inspect
    
    @tax_hash_obj = TaxaCount.new
    @tax_hash     = @tax_hash_obj.create(@taxonomies, @dat_counts_seq)
    
    # puts "HERE0: @tax_hash_obj = " +  @tax_hash_obj.inspect
    # puts "@tax_hash_obj.taxa_count_per_d = " + @tax_hash_obj.taxa_count_per_d.inspect
    
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
    # puts "HERE1: @tax_hash_obj = " +  @tax_hash_obj.inspect
    
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

  it "shows correct numbers on the tax_table page", :js=> true do
    # ActiveRecord::Base.logger = Logger.new(STDOUT) if defined?(ActiveRecord::Base)
    
    puts "-" * 5
    
    project      = Project.first
    puts "\nURA0: "
    project_name = project.project
    dataset      = project.datasets

    Sequence.delete_all
    ActiveRecord::Base.establish_connection
    sql = "INSERT IGNORE INTO sequences (id, sequence_comp, created_at, updated_at) VALUES (1, compress('AGCCTTTGACATCCTAGGACGACTTCTGGAGACAGATTTCTTCCCTTCGGGGACCTAGTGAC'), NOW(), NOW()), (2, compress('TGGTCTTGACATAGTAAGAACTTTCCAGAGATGGATTGGTGCCTTCGGGAACTTACAT'), NOW(), NOW()), (3, compress('TGGCCTTGACATGCAGAGAACTTTCCAGAGATGGATTGGTGCCTTCGGGAACTCTGAC'), NOW(), NOW()), (4, compress('AGGTCTTGACATCCCAGTGACCGTCCTAGAGATAGGATTTTTCTTCGGAACACAGAC'), NOW(), NOW()), (5, compress('TACTCTTGACATCCAGAGAACTTAGCAGAGATGCTTTGGTGCCTTCGGTCTGAGAC'), NOW(), NOW())" 
    ActiveRecord::Base.connection.execute(sql)
    
      # puts "EEE: Sequence.last" + Sequence.last.inspect
       
    
    # @sequence_uniq_info = Array.new
    # @sequence_uniq_info << FactoryGirl.create(:sequence_uniq_info, :sequence_id=>1, :taxonomy_id=>96)
    # @sequence_uniq_info << FactoryGirl.create(:sequence_uniq_info, :sequence_id=>4, :taxonomy_id=>82)
    # @sequence_uniq_info << FactoryGirl.create(:sequence_uniq_info, :sequence_id=>5, :taxonomy_id=>137)
    
    SequenceUniqInfo.create(:sequence_id=>1, :taxonomy_id=>96, :gast_distance => 0.0, :refssu_id => 0, :refssu_count => 4, :rank_id => 4, :refhvr_ids => "v6_AO871", :created_at => Time.now, :updated_at => Time.now)
    SequenceUniqInfo.create(:sequence_id=>4, :taxonomy_id=>82, :gast_distance => 0.0, :refssu_id => 0, :refssu_count => 4, :rank_id => 4, :refhvr_ids => "v6_AO871", :created_at => Time.now, :updated_at => Time.now)
    SequenceUniqInfo.create(:sequence_id=>5, :taxonomy_id=>137, :gast_distance => 0.0, :refssu_id => 0, :refssu_count => 4, :rank_id => 4, :refhvr_ids => "v6_AO871", :created_at => Time.now, :updated_at => Time.now)
    @sequence_uniq_info = SequenceUniqInfo.all
        
    puts "\n@sequence_uniq_info = " + @sequence_uniq_info.inspect
        
    # @sequence_pdr_info = Array.new
    SequencePdrInfo.create(dataset_id: 3, sequence_id: 1, seq_count: 2)
    SequencePdrInfo.create(dataset_id: 3, sequence_id: 4, seq_count: 8)
    SequencePdrInfo.create(dataset_id: 3, sequence_id: 5, seq_count: 3)
    SequencePdrInfo.create(dataset_id: 4, sequence_id: 1, seq_count: 2)
    SequencePdrInfo.create(dataset_id: 4, sequence_id: 4, seq_count: 4)

    @sequence_pdr_info = SequencePdrInfo.all
    # @sequence_pdr_info << FactoryGirl.create(:sequence_pdr_info, dataset_id: 3, sequence_id: 1, seq_count: 2)
    # Sequence.delete(4)    
    # @sequence_pdr_info << FactoryGirl.create(:sequence_pdr_info, dataset_id: 3, sequence_id: 4, seq_count: 8)
    # Sequence.delete(5)    
    # @sequence_pdr_info << FactoryGirl.create(:sequence_pdr_info, dataset_id: 3, sequence_id: 5, seq_count: 3)
    # Sequence.delete(1)    
    # @sequence_pdr_info << FactoryGirl.create(:sequence_pdr_info, dataset_id: 4, sequence_id: 1, seq_count: 2)
    # Sequence.delete(4)
    # 
    # @sequence_pdr_info << FactoryGirl.create(:sequence_pdr_info, dataset_id: 4, sequence_id: 4, seq_count: 4)
    # puts "\nDDD: Dataset.all = " + Dataset.all.inspect
    # 
    # puts "\n@sequence_pdr_info = " + @sequence_pdr_info.inspect
    # puts "\n@sequence_pdr_info.find(2) = " + @sequence_pdr_info.find(2).inspect
    # puts "\n@sequence_pdr_info.find(2).sequence_uniq_info = " + @sequence_pdr_info.find(2).sequence_uniq_info.inspect
    # puts "\nFFF: SequenceUniqInfo.all = " + SequenceUniqInfo.all.inspect
    # puts "\nFFF: Sequence.all = " + Sequence.all.inspect
    # puts "\nSSS1: SequencePdrInfo.find(2) = " + SequencePdrInfo.find(2).inspect
    # puts "\nSSS: SequencePdrInfo.find(2).sequence_uniq_info = " + SequencePdrInfo.find(2).sequence_uniq_info.inspect
    # puts "\nTTT: SequencePdrInfo.find(2).sequence_uniq_info.taxonomy_id = " + SequencePdrInfo.find(2).sequence_uniq_info.taxonomy_id.inspect
    
    # todo: fix the factory, see http://luisalima.github.io/
    # @sequence_uniq_info = Array.new
    # @sequence_uniq_info << FactoryGirl.create(:sequence_uniq_info, :sequence_id=>1, :taxonomy_id=>96)
    # @sequence_uniq_info << FactoryGirl.create(:sequence_uniq_info, :sequence_id=>4, :taxonomy_id=>82)
    # @sequence_uniq_info << FactoryGirl.create(:sequence_uniq_info, :sequence_id=>5, :taxonomy_id=>137)

    
    # puts "@ranks = " + @ranks.inspect
    puts "\nURA55"
    require 'create_ranks_w_data_helper.rb'
    
    puts "\nDDD: Domain.all = " + Domain.all.inspect
    puts "\nCCC: Klass.all = " + Klass.all.inspect

    puts "-" * 5
    puts page.body
    # find(:xpath, "//input[@name='proceed' and @value='save-user-verification']").click
    # 
    # //*[@id="tax_id_2"]
    find(:xpath, "//*[@id=\"basic_taxonomy_selector\"]/label[10]").click
    
    # page.choose('Class')
    # page.choose('tax_id_11')
    check(project_name)
    find_button('Submit').click
    
    page.should have_content("Total count")    
    # HERE: v = #<SequencePdrInfo id: 1, dataset_id: 3, sequence_id: 1, seq_count: 2, classifier: "GAST", created_at: "2013-10-25 21:15:46", updated_at: "2013-10-25 21:15:46">
    # 
    # An error occurred in an after hook
    #   NoMethodError: undefined method `taxonomy_id' for nil:NilClass
    #   occurred at /Users/ashipunova/work/bpc/vamps_rails_app/app/helpers/taxa_count_helper.rb:49:in `block in create_dat_seq_cnts'
    
  end

end

class Hash
  def self.recursive
    new { |hash, key| hash[key] = recursive }
  end
end
