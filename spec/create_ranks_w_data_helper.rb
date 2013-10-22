# Rank.delete_all
# Taxonomy.delete_all
# Domain.delete_all
# Phylum.delete_all
# Klass.delete_all
# Family.delete_all
# Order.delete_all
# Genus.delete_all
# Species.delete_all
# Strain.delete_all

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

@ranks = Array.new
ranks_array.each do |my_hash|
   @ranks.push(FactoryGirl.create(:rank, rank: my_hash[:rank], rank_number: my_hash[:rank_number]))       
end

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
