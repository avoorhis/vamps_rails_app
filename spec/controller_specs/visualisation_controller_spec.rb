require 'spec_helper'

describe "Visualisation" do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.confirm!
    login_as(@user, :scope => :user)
    @projects = "SLM_NIH_Bv4v5"
    @datasets = "1St_156_Marathon", "1St_85_DELANO"
  end

  it "should give correct taxa per dataset counts" do
    my_pdrs = SequencePdrInfo.where(dataset_id: params["dataset_ids"])
    dat_counts_seq = create_dat_seq_cnts(my_pdrs)  
    all_seq_ui     = get_all_sequence_uniq_infos(dat_counts_seq.map { |u| u[:sequence_id] })

    add_tax_id(dat_counts_seq, all_seq_ui)
    puts "URA3 = dat_counts_seq: " + dat_counts_seq.inspect
    
    taxonomies = get_taxonomies(dat_counts_seq)
    tax_hash_obj = TaxaCount.new
    tax_hash     = tax_hash_obj.create(taxonomies, tax_hash, dat_counts_seq)
    puts "\nRES: tax_hash = " + tax_hash.inspect
    
    tax_hash_obj.get_tax_hash_by_tax_ids(tax_hash, [2]) #{3=>13, 4=>6}
    tax_hash_obj.get_tax_hash_by_tax_ids(tax_hash, [2, 3]) #{3=>11, 4=>4}
    puts "[2, 3, 3, 16, 18, 129, 1, 4]"
    puts "HERE:"
    tax_hash_obj.get_tax_hash_by_tax_ids(tax_hash, [2, 3, 3, 16, 18, 129, 129, 4]) #=>{3=>8, 4=>4}
    
  end
  it "should get needed info from db" 
  # do
    # SELECT project, dataset, taxon_string, knt, sdc.classifier, frequency, dataset_count
    # sql = "SELECT project, dataset, taxonomy, knt, classifier, frequency, dataset_count 
           # FROM "
           
           
  # end
  

end