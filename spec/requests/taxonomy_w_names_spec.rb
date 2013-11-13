require 'spec_helper'
include CreateHelpers

describe "TaxonomyWNames" do
  before(:each) do
    create_ranks_w_data
    create_user_and_login
    
    @taxonomies                  = create_taxonomies
    @taxon_strings_upto_rank_obj = TaxonomyWNames.new

    visit "/visualization"      
  end
  
  it "gives correct taxon_strings_upto_rank" do
    # ActiveRecord::Base.logger = Logger.new(STDOUT) if defined?(ActiveRecord::Base)
    taxon_strings_upto_rank = @taxon_strings_upto_rank_obj.create(2, @taxonomies)
    # puts "URA test: taxon_strings_upto_rank = " + taxon_strings_upto_rank.inspect

    expect(taxon_strings_upto_rank).to eq({82=>{:taxon_string=>["Bacteria", "Proteobacteria", "Gammaproteobacteria"], :tax_ids=>[2, 3, 3]}, 96=>{:taxon_string=>["Bacteria", "Actinobacteria", "Clostridia"], :tax_ids=>[2, 4, 6]}, 137=>{:taxon_string=>["Bacteria", "Proteobacteria", "Alphaproteobacteria"], :tax_ids=>[2, 3, 5]}})
    
  end
  

end
