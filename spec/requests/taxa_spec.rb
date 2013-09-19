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
    
    superkingdom_arr = [{:superkingdom => "Archaea"},
    {:superkingdom => "Bacteria"},
    {:superkingdom => "Eukarya"},
    {:superkingdom => "Organelle"},
    {:superkingdom => "Unknown"}]
    @superkingdoms = Array.new
    superkingdom_arr.each do |my_hash|
       @superkingdoms.push(FactoryGirl.create(:superkingdom, superkingdom: my_hash[:superkingdom]))       
    end
    
    puts "UUU"
    puts @superkingdoms.inspect
    
    phylum_arr       = [{:phylum => "Bacteroidetes"},
    {:phylum => "Firmicutes"},
    {:phylum => "Proteobacteria"},
    {:phylum => "Actinobacteria"},
    {:phylum => "Euryarchaeota"}]

    @phylums = Array.new
    phylum_arr.each do |my_hash|
       @phylums.push(FactoryGirl.create(:phylum, phylum: my_hash[:phylum]))       
    end
    
    klass_arr        = [{:klass => "Bacteroidia"},
    {:klass => "Bacilli"},
    {:klass => "Gammaproteobacteria"},
    {:klass => "Betaproteobacteria"},
    {:klass => "Alphaproteobacteria"},
    {:klass => "Clostridia"}]
    @klasses = Array.new
    klass_arr.each do |my_hash|
       @klasses.push(FactoryGirl.create(:klass, klass: my_hash[:klass]))       
    end
    
    order_arr        = [{:order => "Bacteroidales"},
    {:order => "Bacillales"},
    {:order => "Vibrionales"},
    {:order => "Rhodocyclales"},
    {:order => "Actinomycetales"}]
    @orders = Array.new
    order_arr.each do |my_hash|
       @orders.push(FactoryGirl.create(:order, order: my_hash[:order]))       
    end
    
    family_arr       = [{:family => "Bacteroidaceae"},
    {:family => "Staphylococcaceae"},
    {:family => "Vibrionaceae"},
    {:family => "Rhodocyclaceae"},
    {:family => "Microbacteriaceae"}]
    @families = Array.new
    family_arr.each do |my_hash|
       @families.push(FactoryGirl.create(:family, family: my_hash[:family]))       
    end
    
    genus_arr        = [{:genus => "Bacteroides"},
    {:genus => "Staphylococcus"},
    {:genus => "Dechloromonas"},
    {:genus => "Okibacterium"},
    {:genus => "Blastomonas"}]
    @genera = Array.new
    genus_arr.each do |my_hash|
       @genera.push(FactoryGirl.create(:genus, genus: my_hash[:genus]))       
    end
    
    species _arr     = [{:species => "epidermidis"},
    {:species => "fritillariae"},
    {:species => "sp. HPA-87"},
    {:species => "sp. HSA18"},
    {:species => "sp. HSA19"}]
    @species = Array.new
    species_arr.each do |my_hash|
       @species.push(FactoryGirl.create(:species, species: my_hash[:species]))       
    end
    
    strain_arr       = [{:strain => "DSM 5456"},
    {:strain => "strain_NA"}]
    @strains = Array.new
    strain_arr.each do |my_hash|
       @strains.push(FactoryGirl.create(:strain, strain: my_hash[:strain]))       
    end
       
    # aaa = FactoryGirl.create(:taxonomy)
    # puts "Ura2"
    # puts aaa.inspect
    
    # @taxa = Array.new
    # taxa_array.each do |my_hash|
    #    @taxa.push(FactoryGirl.create(:taxon, taxon: my_hash[:taxon], rank_id: my_hash[:rank_id]))       
    # end

    # puts "Ura"
    # puts @taxa.inspect
        
    visit "/visualization"      
  end
  
  it "should show taxonomy" do
    puts "Ura1"
    # puts @taxa.inspect
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
