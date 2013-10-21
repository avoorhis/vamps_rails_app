class VisualizationController < ApplicationController
  
  before_filter :authenticate_user!
  require 'benchmark'  
  include TaxaCountHelper
  
  
  # Andy, I'm collecting all project ids togeteher, is it okay? E.g.: "project_ids"=>["6", "8"], "dataset_ids"=>["3", "4", "238", "239"]

  def index
    # @all_data = get_test_sample_object()
    @datasets_by_project_all = make_datasets_by_project_hash()
    @domains  = Domain.all
    @ranks    = Rank.all.sorted    
  end

  def parse_view
    unless (params.has_key?(:dataset_ids))
      dataset_not_choosen()
      return      
    end
    
    @rank_obj              = Rank.find(params[:tax_id])
    @choosen_projects_w_d  = get_choosen_projects_w_d()
    my_pdrs                = SequencePdrInfo.where(dataset_id: params["dataset_ids"])
    @counts_per_dataset_id = get_counts_per_dataset_id(my_pdrs)
    @taxonomies            = {}
    @dat_counts_seq_tax    = {}    
    @taxonomy_w_cnts_by_d  = get_taxonomy_per_d(my_pdrs)
    
    taxonomy_id_strings_upto_rank = make_taxonomy_id_strings_upto_rank()
    rank_names = get_rank_names()
    rank_number = @rank_obj.rank_number
    
    ranks_to_use = rank_names[0..rank_number]
    
    all_taxa = get_all_taxa_from_db(ranks_to_use)
    puts "AAA: all_taxa = " + all_taxa.inspect
    taxonomy_id_strings_upto_rank.each do |k, v|
      puts "k = #{k.inspect}, v = #{v.inspect}"
      # k = 82, v = [2, 3, 3]
      ranks_to_use.each do |r|
        res   = all_taxa[r].select{|t| t.id == tax_id_val}  
        use order name
        puts "r = #{r.inspect}"
        # r = "domain"
        # r = "phylum"
        # r = "klass"
      end
      
    end
    # res   = all_taxa[rank_name].select{|t| t.id == tax_id_val}  
    
    
    # puts "TTT: @taxonomy_w_cnts_by_d = " + @taxonomy_w_cnts_by_d.inspect
    
    if params[:view]      == "heatmap"
      render :heatmap
    elsif  params[:view]  == "bar_charts"
      render :bar_charts
    else params[:view]    == "tax_table"
      #default
      render "tax_table"
    end    
  end
  
  private
  
  def get_choosen_projects_w_d()
    project_array = Array.new
    d_ids  = params[:dataset_ids]   
    p_objs = get_choosen_projects()
    p_objs.each do |p_obj, d_arr|
      
      choosen_p_w_d            = Hash.new
      choosen_p_w_d[:pid]      = p_obj[:id]
      choosen_p_w_d[:pname]    = p_obj[:project]
      choosen_p_w_d[:datasets] = d_arr.select {|d| d[:id] if d_ids.include? d[:id].to_s}
      project_array << choosen_p_w_d
    end
    return project_array
  end
  
  def get_choosen_projects()
    datasets_by_project_all = make_datasets_by_project_hash()
    p_objs = datasets_by_project_all.select {|p_o| p_o[:id] if params[:project_ids].include? p_o[:id].to_s }
    return p_objs
  end  
  
  def make_datasets_by_project_hash()
    projects = Project.all    
    datasets = Dataset.all        
    datasets_by_project = Hash.new
    projects.each do |p|
      datasets_by_project[p] = datasets.select{|d| d.project_id == p.id}
    end
    return datasets_by_project
  end
  
  def dataset_not_choosen()
    redirect_to visualization_index_path, :alert => 'Choose some data!'
  end
  
  def get_counts_per_dataset_id(my_pdrs)
    counts_per_dataset_id = Hash.new
    
    my_pdrs.each do |d|
      # puts "my_pdrs.each = " + d.inspect
      #<SequencePdrInfo id: 1620, dataset_id: 4, sequence_id: 1005, seq_count: 20, classifier: "GAST", created_at: "2013-08-19 13:04:05", updated_at: "2013-08-19 13:04:05">
      if counts_per_dataset_id[d[:dataset_id]].nil? 
        counts_per_dataset_id[d[:dataset_id]] = d[:seq_count]
      else
        counts_per_dataset_id[d[:dataset_id]] += d[:seq_count]
      end
    end

    # puts "counts_per_dataset_id = " + counts_per_dataset_id.to_s
    return counts_per_dataset_id
  end

  # todo: make one call!
  # Dataset Load (0.3ms)  SELECT `datasets`.* FROM `datasets`
  # Dataset Load (0.3ms)  SELECT `datasets`.* FROM `datasets` WHERE `datasets`.`id` IN (2, 3)
  #   
  
  def get_rank_names()
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
    
  def make_taxa_string(rank_names)
    all_taxa = get_all_taxa_from_db(rank_names)
    puts "URA3 = @dat_counts_seq_tax: " + @dat_counts_seq_tax.inspect
  
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
  
    puts "taxon_strings_per_d " + taxon_strings_per_d.inspect
    puts "=" * 10
  
    return taxon_strings_per_d
  end

  def make_taxa_string_by_rank_per_d()
    # puts "HHHHH: @taxonomy_w_cnts_by_d" + @taxonomy_w_cnts_by_d.inspect
    # HHHHH: @taxonomy_w_cnts_by_d{2=>{3=>{3=>{16=>{18=>{129=>{129=>{4=>{:datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, 5=>{65=>{129=>{129=>{129=>{4=>{:datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>11, 4=>4}}, 4=>{32=>{5=>{52=>{76=>{129=>{4=>{:datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>13, 4=>6}}}
    # TODO:
    # RESULT for rank = klass:  {3=>["Bacteria;Proteobacteria;Gammaproteobacteria", "Bacteria;Actinobacteria;class_NA", "Bacteria;Proteobacteria;Alphaproteobacteria"], 4=>["Bacteria;Proteobacteria;Gammaproteobacteria", "Bacteria;Actinobacteria;class_NA"]}
    # 1) make taxonomy_id strings from Taxonomy by rank
    # taxonomy_id_strings_upto_rank = make_taxonomy_id_strings_upto_rank()
    # rank_names = get_rank_names()
    # rank_number = @rank_obj.rank_number
    # 
    # ranks_to_use = rank_names[0..rank_number]
    # 
    # all_taxa = get_all_taxa_from_db(ranks_to_use)
    # puts "AAA: all_taxa = " + all_taxa.inspect
    # taxonomy_id_strings_upto_rank.each do |taxonomy_id, taxon_ids_arr|
    #   
    #   taxon_ids_arr
    #   # 82=>[2, 3, 3]
    #   res   = all_taxa[rank_name].select{|t| t.id == tax_id_val}  
    # end
    
    # 2) get taxon names
    # 3) arrange by dataset_ids
    # 4) add counts to show in tax_table_view
    
  end
  
  def make_taxonomy_id_strings_upto_rank()
    # from Taxonomy 
    # TODO: refactoring
    
    puts "MMM: @taxonomies = " + @taxonomies.inspect
    puts "MMM1: @rank_obj.rank_number = " + @rank_obj.rank_number.inspect
    rank_names = get_rank_names()
    rank_number = @rank_obj.rank_number
    
    ranks_to_use = rank_names[0..rank_number]
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
  
  # def make_taxa_string_by_rank_per_d()
  #    rank                = @rank_obj.rank_number + 1
  #    rank_names          = get_rank_names()
  #    taxon_strings_per_d = make_taxa_string(rank_names)
  #    
  #    taxon_string_by_rank_per_d  = Hash.new{|hash, key| hash[key] = []}
  # 
  # 
  #    taxon_strings_per_d.each do |dataset_id, taxon_string_arr|
  #      taxon_string_arr.each do |taxon_string_orig|
  #        taxon_string_by_rank = taxon_string_orig.take(rank)
  #        # .join(";")
  #        puts "UUU " + taxon_string_by_rank.inspect
  #        puts "-" * 7
  #        taxon_string_by_rank_per_d[dataset_id] << taxon_string_by_rank
  #      end
  #    end
  #    puts "taxon_string_by_rank_per_d = " + taxon_string_by_rank_per_d.inspect
  #    puts "-" * 7
  #    # UUU {3=>["Bacteria;Proteobacteria;Gammaproteobacteria;Enterobacteriales;Enterobacteriaceae", "Bacteria;Actinobacteria;class_NA;Actinomycetales;Intrasporangiaceae", "Bacteria;Proteobacteria;Alphaproteobacteria;order_NA;family_NA"], 4=>["Bacteria;Proteobacteria;Gammaproteobacteria;Enterobacteriales;Enterobacteriaceae", "Bacteria;Actinobacteria;class_NA;Actinomycetales;Intrasporangiaceae"]}
  #    return taxon_string_by_rank_per_d
  #  end
  #  
  
end