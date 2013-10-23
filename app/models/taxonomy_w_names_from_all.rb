class TaxonomyWNamesFromAll 
  #   # TODO:
  #   # RESULT for rank = klass:  {3=>["Bacteria;Proteobacteria;Gammaproteobacteria", "Bacteria;Actinobacteria;class_NA", "Bacteria;Proteobacteria;Alphaproteobacteria"], 4=>["Bacteria;Proteobacteria;Gammaproteobacteria", "Bacteria;Actinobacteria;class_NA"]}
  # 1) make taxonomy_id strings from Taxonomy by rank
  # 2) get taxon names

  attr_accessor :taxon_strings_by_t_id

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def create(rank_number, taxonomies, dat_counts_seq_tax)
    @taxonomies         = taxonomies
    @dat_counts_seq_tax = dat_counts_seq_tax
    rank_names          = get_rank_names_all()
    taxon_strings_per_d = make_taxa_string(rank_names)
    # puts "taxon_strings_per_d from obj1" + taxon_strings_per_d.inspect
    # puts "=" * 10
    return taxon_strings_per_d
  end

  private
  
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
  
  
  def make_taxa_string(rank_names)
    all_taxa = get_all_taxa_from_db(rank_names)
    # puts "URA3 = @dat_counts_seq_tax: " + @dat_counts_seq_tax.inspect
  
    taxon_strings_per_d  = Hash.new{|hash, key| hash[key] = []}
  
    @dat_counts_seq_tax.each do |ob|
      # puts "from loop: ob[:dataset_id] = " + ob[:dataset_id].inspect 
      # puts "from loop: ob[:taxonomy_id] = " + ob[:taxonomy_id].inspect 
      # puts "*" * 10
  
      @taxonomies.each do |taxonomy|
        taxon_arr  = []
        # puts "from loop: taxonomy = " + taxonomy.inspect 
        # puts "*" * 10
        rank_names.each do |rank_name|
          taxon_arr << get_taxon(taxonomy, rank_name, all_taxa)    
        end
        # puts "from loop: taxon_arr = " + taxon_arr.inspect 
        # puts "*" * 10
        taxon_strings_per_d[ob[:dataset_id]] << taxon_arr
      end    
    end 
  
    # puts "taxon_strings_per_d " + taxon_strings_per_d.inspect
    # puts "=" * 10
  
    return taxon_strings_per_d
  end
  
  def get_taxon(taxonomy, rank_name, all_taxa)
    id_name    = rank_name + "_id"    
    tax_id_val = taxonomy.attributes[id_name]
    # puts "LLL: taxonomy.attributes[id_name] = " + taxonomy.attributes[id_name].inspect
    
    res   = all_taxa[rank_name].select{|t| t.id == tax_id_val}  
    # puts "LLL1: res = " + res.inspect
    taxon = res[0][rank_name]  
    # puts "LLL2: taxon = " + taxon.inspect
    # LLL: taxonomy.attributes[id_name] = 5
    # LLL1: res = [#<Klass id: 5, klass: "Alphaproteobacteria">]
    # LLL2: taxon = "Alphaproteobacteria"
    
    return taxon
  end
   
  def get_rank_names_all()
    ranks      = Rank.all.sorted 
    rank_names = []     
    ranks.map {|rank| rank.rank == "class" ? rank_names << "klass" : rank_names << rank.rank}
    rank_names.delete("NA")
    # puts "RRRRR: rank_names = " + rank_names.inspect
    return rank_names
  end
   
  
end