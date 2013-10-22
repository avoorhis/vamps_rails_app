class TaxonomyWNames 
  # 1) make taxonomy_id strings from Taxonomy by rank
  # 2) get taxon names

  attr_accessor :taxon_strings_by_t_id

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def create(rank_obj, taxonomies)  
    @rank_obj   = rank_obj
    @taxonomies = taxonomies
    # @taxon_strings_by_t_id        = Hash.new{|hash, key| hash[key] = []}
    ranks_to_use                  = get_ranks_to_use()    
    taxonomy_id_strings_upto_rank = make_taxonomy_id_strings_upto_rank(ranks_to_use)
    @taxon_strings_by_t_id        = make_taxon_strings_by_t_id(ranks_to_use, taxonomy_id_strings_upto_rank)
  end

  private
  
  def get_ranks_to_use()  
    puts "MMM1: @rank_obj.rank_number = " + @rank_obj.rank_number.inspect
    rank_names  = get_rank_names_all()
    rank_number = @rank_obj.rank_number  
    rank_names[0..rank_number]
  end
  
  
  def get_rank_names_all()
    ranks      = Rank.all.sorted 
    rank_names = []     
    ranks.map {|rank| rank.rank == "class" ? rank_names << "klass" : rank_names << rank.rank}
    rank_names.delete("NA")
    puts "RRRRR: rank_names = " + rank_names.inspect
    return rank_names
  end
  
  def get_all_taxa_from_db(rank_names)
    # puts "rank_names = " + rank_names.inspect
    all_taxa   = Hash.new{|hash, key| hash[key] = []}
    rank_names.each do |rank_name|
      all_taxa[rank_name] = rank_name.camelize.constantize.all
    end
    # puts "all_taxa = " + all_taxa.inspect
    # {"domain"=>#<ActiveRecord::Relation [#<Domain id: 1, domain: "Archaea">, #<Domain id: 2, domain: "Bacteria">, #<Domain id: ...
    return all_taxa
  end
  def make_taxonomy_id_strings_upto_rank(ranks_to_use)
    # from Taxonomy 
    # TODO: refactoring
    
    puts "MMM: @taxonomies = " + @taxonomies.inspect
    rank_id_names = ranks_to_use.map{|rank_name| rank_name + "_id" }
    puts "MMM2: rank_id_names = " + rank_id_names.inspect
    
    taxonomy_id_strings_upto_rank = Hash.new{|hash, key| hash[key] = []}
    @taxonomies.map{|t| tax_ids = []; t.attributes.select{|a| tax_ids << t[a] if rank_id_names.include? a }; taxonomy_id_strings_upto_rank[t[:id]] = tax_ids}
    puts "EEE: taxonomy_id_strings_upto_rank = " + taxonomy_id_strings_upto_rank.inspect
    # EEE: taxonomy_id_strings_upto_rank = {82=>[2, 3, 3], 96=>[2, 4, 32], 137=>[2, 3, 5]}
    
    return taxonomy_id_strings_upto_rank
    # res = @taxonomies.map{|t| puts t.attributes}
    # {"id"=>82, "domain_id"=>2, "phylum_id"=>3, "klass_id"=>3, "order_id"=>16, "family_id"=>18, "genus_id"=>129, "species_id"=>129, "strain_id"=>4, "created_at"=>Mon, 19 Aug 2013 08:44:13 EDT -04:00, "updated_at"=>Mon, 19 Aug 2013 08:44:13 EDT -04:00}
    
    # res = @taxonomies.map(&:id)
    # LLL1: res = [82, 96, 137]
    
    # .each do |taxonomy|
    #   taxonomy_id_strings_upto_rank  = []
    #   # puts "from loop: taxonomy = " + taxonomy.inspect 
    #   # puts "*" * 10
    #   # res   = taxonomy.select{|t| t.id == tax_id_val}  
    #   # ranks_to_use = ["domain", "phylum", "klass"]
    #   
    #   res = taxonomy.map(&:id)
    #   # .select{|t| taxonomy.attributes[id_name] if rank_id_names.include? id_name}  
      # puts "\n---------\nLLL1: res = " + res.inspect
    #     
    #     # tax_id  = taxonomy.attributes[id_name]
    #     # puts "\n---------\nLLL: taxonomy.attributes[id_name] = " + tax_id.inspect
    #   # end
    # end
        # res   = all_taxa[rank_name].select{|t| t.id == tax_id_val}  
        
    # get_taxon(taxonomy, rank_name, all_taxa) 
    
    
    # make_taxa_string(ranks_to_use)
  end
  
  
  def make_taxon_strings_by_t_id(ranks_to_use, taxonomy_id_strings_upto_rank)
    all_taxa = get_all_taxa_from_db(ranks_to_use)
    puts "AAA: all_taxa = " + all_taxa.inspect
    puts "AAA: ranks_to_use = " + ranks_to_use.inspect
    puts "AAA: taxonomy_id_strings_upto_rank = " + taxonomy_id_strings_upto_rank.inspect
    taxon_strings_upto_rank = Hash.new{|hash, key| hash[key] = []}
    
    taxonomy_id_strings_upto_rank.each do |taxonomy_id, taxon_ids_arr|
      # puts "taxonomy_id = #{taxonomy_id.inspect}, taxon_ids_arr = #{taxon_ids_arr.inspect}"
      # taxonomy_id = 82, taxon_ids_arr = [2, 3, 3]
      taxon_arr = []
      (0...ranks_to_use.size).each do |i|
        # puts "i = #{i.inspect}"
        # puts "ranks_to_use[#{i}] = " + ranks_to_use[i].inspect
        # puts "taxon_ids_arr[#{i}] = " + taxon_ids_arr[i].inspect
        taxon = all_taxa[ranks_to_use[i]].select{|t| t.id == taxon_ids_arr[i]}[0][ranks_to_use[i]]  
        # puts "taxon = " + taxon.inspect
        taxon_arr << taxon
        # ranks_to_use[2] = "klass"
        # taxon_ids_arr[2] = 32
        # res = [#<Klass id: 32, klass: "class_NA">]
      # ranks_to_use.each do |r|
        # res   = all_taxa[r].select{|t| t.id == tax_id_val}  
        # use order name
        # r = "domain"
        # r = "phylum"
        # r = "klass"
      end    
      # puts "taxon_arr = " + taxon_arr.inspect
      # taxon_arr = ["Bacteria", "Proteobacteria", "Gammaproteobacteria"]
      
      taxon_strings_upto_rank[taxonomy_id] = taxon_arr
      # {82=>[2, 3, 3], 96=>[2, 4, 32], 137=>[2, 3, 5]}
    end
    puts "taxon_strings_upto_rank = " + taxon_strings_upto_rank.inspect
    # taxon_strings_upto_rank = {82=>["Bacteria", "Proteobacteria", "Gammaproteobacteria"], 96=>["Bacteria", "Actinobacteria", "class_NA"], 137=>["Bacteria", "Proteobacteria", "Alphaproteobacteria"]}
    # todo: benchmark, what's' faster for choosen taxonomy ids
    # 1) every time get taxon_names up to the choosen rank
    # 2) have all taxon names and cut down to the choosen rank every time (genus: 128kb, 2591; species: 176 kb, 4527)
    # do that in the taxonomy object?
    return taxon_strings_upto_rank
  end
  
  
end