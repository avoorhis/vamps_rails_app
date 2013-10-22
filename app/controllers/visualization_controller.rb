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
    
    rank_obj               = Rank.find(params[:tax_id])
    rank_number            = rank_obj.rank_number
    @choosen_projects_w_d  = get_choosen_projects_w_d()
    my_pdrs                = SequencePdrInfo.where(dataset_id: params["dataset_ids"])
    @counts_per_dataset_id = get_counts_per_dataset_id(my_pdrs)
    @taxonomies            = {}
    @dat_counts_seq_tax    = {}    
    @taxonomy_w_cnts_by_d  = get_taxonomy_per_d(my_pdrs)
    
    # 1) make taxonomy_id strings from Taxonomy by rank
    # 2) get taxon names
    # 3) arrange by dataset_ids
    # 4) add counts to show in tax_table_view    
    
    (1..100).each do
      result = Benchmark.measure do
        taxon_strings_upto_rank_obj = TaxonomyWNames.new
        taxon_strings_upto_rank     = taxon_strings_upto_rank_obj.create(rank_number, @taxonomies)
        taxon_strings_per_d         = organize_tax_by_d_id(taxon_strings_upto_rank)         
      end
      puts "TaxonomyWNames result " + result.to_s
    
      result1 = Benchmark.measure do
        taxon_strings_upto_rank_obj1 = TaxonomyWNamesFromAll.new
        taxon_strings_upto_rank1     = taxon_strings_upto_rank_obj1.create(rank_number, @taxonomies, @dat_counts_seq_tax)
        croped_taxon_strings_per_d   = cut_taxon_strings_per_d_to_rank(rank_number, taxon_strings_upto_rank1)    
      end
      puts "TaxonomyWNamesFromAll result " + result1.to_s 
      puts "-" * 10
    end
    # taxon_strings_upto_rank_obj = TaxonomyWNames.new
    # taxon_strings_upto_rank     = taxon_strings_upto_rank_obj.create(rank_number, @taxonomies)
    # taxon_strings_per_d = organize_tax_by_d_id(taxon_strings_upto_rank) 
    # puts "NNN: taxon_strings_per_d result " + taxon_strings_per_d.inspect 
    # taxon_strings_upto_rank_obj = TaxonomyWNames.new
    # taxon_strings_upto_rank     = taxon_strings_upto_rank_obj.create(rank_number, @taxonomies)
    # puts "YYY: taxon_strings_upto_rank = " + taxon_strings_upto_rank.inspect
    # 
    # taxon_strings_upto_rank_obj1 = TaxonomyWNamesFromAll.new
    # taxon_strings_upto_rank1     = taxon_strings_upto_rank_obj1.create(rank_number, @taxonomies, @dat_counts_seq_tax)
    # croped_taxon_strings_per_d   = cut_taxon_strings_per_d_to_rank(rank_number, taxon_strings_upto_rank1)    
    # puts "YYY3: croped_taxon_strings_per_d = " + croped_taxon_strings_per_d.inspect

    # ranks_to_use                  = get_ranks_to_use()    
    # taxonomy_id_strings_upto_rank = make_taxonomy_id_strings_upto_rank(ranks_to_use)
    # taxon_strings_by_t_id         = make_taxon_strings_by_t_id(ranks_to_use, taxonomy_id_strings_upto_rank)
    
    
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
  
  # 
  # def make_taxa_string(rank_names)
  #   all_taxa = get_all_taxa_from_db(rank_names)
  #   puts "URA3 = @dat_counts_seq_tax: " + @dat_counts_seq_tax.inspect
  # 
  #   taxon_strings_per_d  = Hash.new{|hash, key| hash[key] = []}
  # 
  #   @dat_counts_seq_tax.each do |ob|
  #     # puts "from loop: ob[:dataset_id] = " + ob[:dataset_id].inspect 
  #     # puts "from loop: ob[:taxonomy_id] = " + ob[:taxonomy_id].inspect 
  #     # puts "*" * 10
  # 
  #     @taxonomies.each do |taxonomy|
  #       taxon_arr  = []
  #       # puts "from loop: taxonomy = " + taxonomy.inspect 
  #       # puts "*" * 10
  #       rank_names.each do |rank_name|
  #         taxon_arr << get_taxon(taxonomy, rank_name, all_taxa)    
  #       end
  #       # puts "from loop: taxon_arr = " + taxon_arr.inspect 
  #       # puts "*" * 10
  #       taxon_strings_per_d[ob[:dataset_id]] << taxon_arr
  #     end    
  #   end 
  # 
  #   puts "taxon_strings_per_d " + taxon_strings_per_d.inspect
  #   puts "=" * 10
  # 
  #   return taxon_strings_per_d
  # end

  # def make_taxa_string_by_rank_per_d()
  #   # puts "HHHHH: @taxonomy_w_cnts_by_d" + @taxonomy_w_cnts_by_d.inspect
  #   # HHHHH: @taxonomy_w_cnts_by_d{2=>{3=>{3=>{16=>{18=>{129=>{129=>{4=>{:datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, 5=>{65=>{129=>{129=>{129=>{4=>{:datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>11, 4=>4}}, 4=>{32=>{5=>{52=>{76=>{129=>{4=>{:datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>13, 4=>6}}}
  #   # TODO:
  #   # RESULT for rank = klass:  {3=>["Bacteria;Proteobacteria;Gammaproteobacteria", "Bacteria;Actinobacteria;class_NA", "Bacteria;Proteobacteria;Alphaproteobacteria"], 4=>["Bacteria;Proteobacteria;Gammaproteobacteria", "Bacteria;Actinobacteria;class_NA"]}
  #   # 1) make taxonomy_id strings from Taxonomy by rank
  #   # taxonomy_id_strings_upto_rank = make_taxonomy_id_strings_upto_rank()
  #   # rank_names = get_rank_names_all()
  #   # rank_number = @rank_obj.rank_number
  #   # 
  #   # ranks_to_use = rank_names[0..rank_number]
  #   # 
  #   # all_taxa = get_all_taxa_from_db(ranks_to_use)
  #   # puts "AAA: all_taxa = " + all_taxa.inspect
  #   # taxonomy_id_strings_upto_rank.each do |taxonomy_id, taxon_ids_arr|
  #   #   
  #   #   taxon_ids_arr
  #   #   # 82=>[2, 3, 3]
  #   #   res   = all_taxa[rank_name].select{|t| t.id == tax_id_val}  
  #   # end
  #   
  #   # 2) get taxon names
  #   # 3) arrange by dataset_ids
  #   # 4) add counts to show in tax_table_view
  #   
  # end
  # 
  # def make_taxa_string_by_rank_per_d()
  #    rank                = @rank_obj.rank_number + 1
  #    rank_names          = get_rank_names_all()
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
  
  def cut_taxon_strings_per_d_to_rank(rank_number, taxon_strings_upto_rank1)
    croped_taxon_strings_per_d = Hash.new{|hash, key| hash[key] = []}
    
    # taxon_strings_upto_rank1 = from obj1{3=>[["Bacteria", "Proteobacteria", "Gammaproteobacteria", "Enterobacteriales", "Enterobacteriaceae", "genus_NA", "", "strain_NA"], ["Bacteria", "Actinobacteria", "class_NA", "Actinomycetales", "Intrasporangiaceae", "Serinicoccus", "", "strain_NA"], ["Bacteria", "Proteobacteria
    taxon_strings_upto_rank1.each do |d_id, tax_str_arrs|
      # puts "YYY1: d_id = #{d_id.to_s}, tax_str_arrs = " + tax_str_arrs.inspect
      croped_taxon_strings_per_d[d_id] = tax_str_arrs.map{|t| t[0..rank_number]}.uniq
      puts "YYY2: croped_taxon_strings_per_d = " + croped_taxon_strings_per_d.inspect
    end
    return croped_taxon_strings_per_d
  end
  
  def organize_tax_by_d_id(taxon_strings_upto_rank) 
    taxon_strings_per_d = Hash.new{|hash, key| hash[key] = []}
    taxon_strings_upto_rank.each do |tax_id, taxon_str_arr|
      # puts "UUU0: tax_id = " + tax_id.inspect
      # puts "UUU01: taxon_str_arr = " + taxon_str_arr.inspect
      @dat_counts_seq_tax.each do |dat_counts_seq_tax_hash|
        # a = dat_counts_seq_tax_hash[0].select {|h| h[:dataset_id] if h[:taxonomy_id].to_s == tax_id.to_s }
        # puts "UUU1: dat_counts_seq_tax_hash = " + dat_counts_seq_tax_hash.inspect
        # puts "UUU11: dat_counts_seq_tax_hash[:taxonomy_id] = " + dat_counts_seq_tax_hash[:taxonomy_id].inspect
        # UUU1: dat_counts_seq_tax_hash = {:dataset_id=>3, :sequence_id=>1001, :seq_count=>2, :taxonomy_id=>96}
        taxon_strings_per_d[dat_counts_seq_tax_hash[:dataset_id]] << taxon_str_arr.uniq
        # puts "UUU12: taxon_strings_per_d = " + taxon_strings_per_d.inspect
        
      end
      # puts "UUU2: taxon_strings_per_d = " + taxon_strings_per_d.inspect
    end
  # YYY: taxon_strings_upto_rank = {82=>["Bacteria", "Proteobacteria", "Gammaproteobacteria"], 96=>["Bacteria", "Actinobacteria", "class_NA"], 137=>["Bacteria", "Proteobacteria", "Alphaproteobacteria"]}
  # URA3 = @dat_counts_seq_tax: [{:dataset_id=>3, :sequence_id=>1001, :seq_count=>2, :taxonomy_id=>96}, {:dataset_id=>3, :sequence_id=>1002, :seq_count=>103, :taxonomy_id=>214}, {:dataset_id=>3, :sequence_id=>1004, :seq_count=>8, :taxonomy_id=>82}, {:dataset_id=>3, :sequence_id=>1005, :seq_count=>203, :taxonomy_id=>214}, {:dataset_id=>3, :sequence_id=>1007, :seq_count=>3, :taxonomy_id=>137}, {:dataset_id=>4, :sequence_id=>1001, :seq_count=>2, :taxonomy_id=>96}, {:dataset_id=>4, :sequence_id=>1002, :seq_count=>13, :taxonomy_id=>214}, {:dataset_id=>4, :sequence_id=>1004, :seq_count=>4, :taxonomy_id=>82}, {:dataset_id=>4, :sequence_id=>1005, :seq_count=>20, :taxonomy_id=>214}]
    taxon_strings_per_d.map{|id, val_arr| taxon_strings_per_d[id] = val_arr.uniq}
    return taxon_strings_per_d
  end
  
end