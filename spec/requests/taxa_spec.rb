require 'spec_helper'

describe "Taxa" do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.confirm!    
    login_as(@user, :scope => :user)

    @projects = @user.projects
    ranks_array = [{:rank => "NA", :rank_number => 10},
    {:rank => "class", :rank_number => 2},
    {:rank => "domain", :rank_number => 0},
    {:rank => "family", :rank_number => 4},
    {:rank => "genus", :rank_number => 5},
    {:rank => "order", :rank_number => 3},
    {:rank => "phylum", :rank_number => 1},
    {:rank => "species", :rank_number => 6},
    {:rank => "strain", :rank_number => 7},
    {:rank => "superkingdom", :rank_number => 12}]
    
    @ranks = Array.new
    ranks_array.each do |my_hash|
       @ranks.push(FactoryGirl.create(:rank, rank: my_hash[:rank], rank_number: my_hash[:rank_number]))       
    end
    
    taxa_array = 
      [{:taxon => "Archaea", :rank_id => 10},
        {:taxon => "Bacteria", :rank_id => 10},
        {:taxon => "", :rank_id => 8},
        {:taxon => "epidermidis", :rank_id => 8},
        {:taxon => "uncultured crenarchaeote pBA3", :rank_id => 8},
        {:taxon => "uncultured Desulfurococcaceae archaeon", :rank_id => 8},
        {:taxon => "agglomerans", :rank_id => 8},
        {:taxon => "Bacteroidetes", :rank_id => 7},
        {:taxon => "Firmicutes", :rank_id => 7},
        {:taxon => "Crenarchaeota", :rank_id => 7},
        {:taxon => "Proteobacteria", :rank_id => 7},
        {:taxon => "Bacteroidales", :rank_id => 6},
        {:taxon => "Desulfurococcales", :rank_id => 6},
        {:taxon => "Sphingomonadales", :rank_id => 6},
        {:taxon => "Pseudomonadales", :rank_id => 6},
        {:taxon => "Lactobacillales", :rank_id => 6},
        {:taxon => "Enterobacteriales", :rank_id => 6},
        {:taxon => "Bacillales", :rank_id => 6},
        {:taxon => "Staphylococcus", :rank_id => 5},
        {:taxon => "Bacteroides", :rank_id => 5},
        {:taxon => "Acinetobacter", :rank_id => 5},
        {:taxon => "Marinobacter", :rank_id => 5},
        {:taxon => "Streptococcus", :rank_id => 5},
        {:taxon => "Pantoea", :rank_id => 5},
        {:taxon => "Bacteroidaceae", :rank_id => 4},
        {:taxon => "Desulfurococcaceae", :rank_id => 4},
        {:taxon => "Erythrobacteraceae", :rank_id => 4},
        {:taxon => "Moraxellaceae", :rank_id => 4},
        {:taxon => "Alteromonadaceae", :rank_id => 4},
        {:taxon => "Streptococcaceae", :rank_id => 4},
        {:taxon => "Enterobacteriaceae", :rank_id => 4},
        {:taxon => "Staphylococcaceae", :rank_id => 4},
        {:taxon => "Vibrionaceae", :rank_id => 4},
        {:taxon => "Bacilli", :rank_id => 2},
        {:taxon => "Thermoprotei", :rank_id => 2},
        {:taxon => "Alphaproteobacteria", :rank_id => 2},
        {:taxon => "Gammaproteobacteria", :rank_id => 2},
        {:taxon => "Bacteroidia", :rank_id => 2}
        ]
    
    # aaa = FactoryGirl.create(:taxonomy)
    # puts "Ura2"
    # puts aaa.inspect
    
    @taxa = Array.new
    taxa_array.each do |my_hash|
       @taxa.push(FactoryGirl.create(:taxon, taxon: my_hash[:taxon], rank_id: my_hash[:rank_id]))       
    end

    # puts "Ura"
    # puts @taxa.inspect
        
    visit "/visualization"      
  end
  
  it "should show taxonomy" do
    puts "Ura1"
    puts @taxa.inspect
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
