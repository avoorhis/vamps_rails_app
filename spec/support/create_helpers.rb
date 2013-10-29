module CreateHelpers

  def create_user_and_login
    user = FactoryGirl.create(:user)
    user.confirm!    
    login_as(user, :scope => :user)
    user    
  end
  
  def create_taxonomies
    taxonomies = Array.new
    taxonomies << FactoryGirl.create(:taxonomy, id: 82, domain_id: 2, phylum_id: 3, klass_id: 3, order_id: 16, family_id: 18, genus_id: 129, species_id: 129, strain_id: 4)
    taxonomies << FactoryGirl.create(:taxonomy, id: 96, domain_id: 2, phylum_id: 4, klass_id: 32, order_id: 5, family_id: 52, genus_id: 76, species_id: 129, strain_id: 4)
    taxonomies << FactoryGirl.create(:taxonomy, id: 137, domain_id: 2, phylum_id: 3, klass_id: 5, order_id: 65, family_id: 129, genus_id: 129, species_id: 129, strain_id: 4)    
  end
  
  def create_ranks
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
    ranks = Array.new
    ranks_array.each do |my_hash|
       ranks.push(FactoryGirl.create(:rank, rank: my_hash[:rank], rank_number: my_hash[:rank_number]))       
    end
    return ranks
  end
  
  def create_ranks_w_data
    # ActiveRecord::Base.logger = Logger.new(STDOUT) if defined?(ActiveRecord::Base)

    create_ranks
    
    domain_arr = [{:domain => "Archaea"},
    {:domain => "Bacteria"},
    {:domain => "Eukarya"},
    {:domain => "Organelle"},
    {:domain => "Unknown"}]

    @domains = Array.new
    domain_arr.each do |my_hash|
       @domains.push(FactoryGirl.create(:domain, domain: my_hash[:domain]))       
    end

    phylum_arr       = [{:phylum => "Bacteroidetes"},
    {:phylum => "Firmicutes"},
    {:phylum => "Proteobacteria"},
    {:phylum => "Actinobacteria"},
    {:phylum => "Euryarchaeota"}]

    @phylums = Array.new
    phylum_arr.each do |my_hash|
       @phylums.push(FactoryGirl.create(:phylum, phylum: my_hash[:phylum]))       
    end

    klass_arr        = [{id: 1, :klass => "Bacteroidia"},
    {id: 2, :klass => "Bacilli"},
    {id: 3, :klass => "Gammaproteobacteria"},
    {id: 4, :klass => "Betaproteobacteria"},
    {id: 5, :klass => "Alphaproteobacteria"},
    {id: 32, :klass => "Clostridia"}]
    @klasses = Array.new
    klass_arr.each do |my_hash|
       @klasses.push(FactoryGirl.create(:klass, id: my_hash[:id], klass: my_hash[:klass]))       
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

    species_arr     = [{:species => "epidermidis"},
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

  end
end

# RSpec.configure do |config|
#   config.include CreateHelpers
#   # , :type=>:api #apply to all spec for apis folder
# end
