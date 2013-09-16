require 'spec_helper'

describe "Taxa" do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.confirm!    
    login_as(@user, :scope => :user)

    @projects = @user.projects
    # @ranks    = FactoryGirl.create(:rank)
    # @taxa     = Array.new(3) { FactoryGirl.build(:taxon) } 
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
    
    puts "Ura"
    puts @ranks.inspect
    
    taxa_array = 
      [{:taxon => "Archaea", :rank_id => 10},
        {:taxon => "Bacteria", :rank_id => 10},
        {:taxon => "Bacteroidaceae", :rank_id => 4},
        {:taxon => "", :rank_id => 8},
        {:taxon => "Bacteroidetes", :rank_id => 7},
        {:taxon => "Bacteroidales", :rank_id => 6},
        {:taxon => "Bacteroides", :rank_id => 5},
        {:taxon => "Bacteroidia", :rank_id => 2},
        {:taxon => "Staphylococcaceae", :rank_id => 4},
        {:taxon => "epidermidis", :rank_id => 8},
        {:taxon => "Firmicutes", :rank_id => 7},
        {:taxon => "Bacillales", :rank_id => 6},
        {:taxon => "Staphylococcus", :rank_id => 5},
        {:taxon => "Bacilli", :rank_id => 2},
        {:taxon => "Vibrionaceae", :rank_id => 4},
        {:taxon => "Proteobacteria", :rank_id => 7}]
    
    @taxa = Array.new
    taxa_array.each do |my_hash|
       @taxa.push(FactoryGirl.create(:taxon, taxon: my_hash[:taxon], rank_id: my_hash[:rank_id]))       
    end

    
    # hash.each { |key,value| block }
    # @taxa = Array.new
    # taxon = FactoryGirl.build(:taxon, taxon: "Archaea")
    # @taxa.push(taxon)
    # taxon = FactoryGirl.build(:taxon, taxon: "Bacteria")
    # @taxa.push(taxon)
    puts "Ura"
    puts @taxa.inspect
        
    visit "/visualization"      
  end
  
  it "should show taxonomy" do
    puts page.body
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
