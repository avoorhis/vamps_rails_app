require 'spec_helper'
# include TaxaCountHelper
include CreateHelpers

describe "TaxonomyWNames" do
  before(:each) do
    create_ranks_w_data
    
    @user = FactoryGirl.create(:user)
    @user.confirm!    
    login_as(@user, :scope => :user)
    
    @taxonomies = create_taxonomies
    @taxon_strings_upto_rank_obj = TaxonomyWNames.new
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
  
  it "gives correct taxon_strings_upto_rank" do
    # ActiveRecord::Base.logger = Logger.new(STDOUT) if defined?(ActiveRecord::Base)
    taxon_strings_upto_rank = @taxon_strings_upto_rank_obj.create(2, @taxonomies)
    # puts "URA test: taxon_strings_upto_rank = " + taxon_strings_upto_rank.inspect

    taxon_strings_upto_rank.should == {82=>{:taxon_string=>["Bacteria", "Proteobacteria", "Gammaproteobacteria"], :tax_ids=>[2, 3, 3]}, 96=>{:taxon_string=>["Bacteria", "Actinobacteria", "Clostridia"], :tax_ids=>[2, 4, 32]}, 137=>{:taxon_string=>["Bacteria", "Proteobacteria", "Alphaproteobacteria"], :tax_ids=>[2, 3, 5]}}
    
  end
  

end
