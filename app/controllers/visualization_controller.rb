class VisualizationController < ApplicationController
  
  before_filter :authenticate_user!
  protect_from_forgery except: :parse_view
  
  require 'benchmark'  
  include TaxaCountHelper
  @@counts_per_dataset_id = Hash.new
  @@choosen_projects_w_d  = Hash.new
  @@taxonomy_w_cnts_by_d  = Hash.new
    
  # Andy, I'm collecting all project ids togeteher, is it okay? E.g.: "project_ids"=>["6", "8"], "dataset_ids"=>["3", "4", "238", "239"]

  def index
    @datasets_by_project_all = make_datasets_by_project_hash()
    @domains  = Domain.all
    @ranks    = Rank.all.sorted    
  end

  def parse_view
    # todo: simplify, comment, see https://codeclimate.com/repos/526bee0356b1022c5301920b/VisualizationController
    unless (params.has_key?(:dataset_ids))
      dataset_not_choosen()
      return      
    end
    
    result = Benchmark.measure do
      @@choosen_projects_w_d  = get_choosen_projects_w_d()
    end
    puts "get_choosen_projects_w_d() result " + result.to_s
    
    my_pdrs = Hash.new
    result = Benchmark.measure do
      my_pdrs = SequencePdrInfo.taxonomy_ids.where(dataset_id: params["dataset_ids"].uniq)
    end
    # puts "PPP: my_pdrs = " + my_pdrs.inspect
    puts "SequencePdrInfo.where(dataset_id: params[\"dataset_ids\"].uniq) result " + result.to_s
    
    result = Benchmark.measure do
      @@counts_per_dataset_id = get_counts_per_dataset_id(my_pdrs)
    end
    puts "get_counts_per_dataset_id(my_pdrs) result " + result.to_s
    
    create_taxonomy_w_counts_to_show(Rank.find(params[:tax_id]).rank_number, my_pdrs)
    
    @counts_per_dataset_id = @@counts_per_dataset_id
    @choosen_projects_w_d  = @@choosen_projects_w_d
    
    what_to_show(params[:view])
  end

  def what_to_show(to_render = params[:view])
    puts "TTT1: to_render = " + to_render.inspect
    
    puts "TTT: params = " + params.inspect
    puts "RRR: @@counts_per_dataset_id = " + @@counts_per_dataset_id.inspect
    @counts_per_dataset_id = @@counts_per_dataset_id
    @choosen_projects_w_d  = @@choosen_projects_w_d
    @taxonomy_w_cnts_by_d  = @@taxonomy_w_cnts_by_d
    
    render to_render
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

  def make_taxon_strings_w_counts_per_d(taxonomy_by_t_id_upto_rank, tax_hash_obj, taxonomy_per_d)
    # todo: move to an object?
    taxon_strings_w_counts_per_d = Hash.recursive
    taxonomy_by_t_id_upto_rank.each do |taxonomy_id, taxonomy_hash|
      taxon_strings_w_counts_per_d[taxonomy_hash[:taxon_string]] = fill_zeros(tax_hash_obj.get_cnts_per_dataset_ids_by_tax_ids(taxonomy_per_d, taxonomy_hash[:tax_ids]))
    end
    # puts "\nPPP, taxon_strings_w_counts_per_d = " + taxon_strings_w_counts_per_d.inspect
    # PPP, taxon_strings_w_counts_per_d = {82=>["Bacteria", "Proteobacteria", "Gammaproteobacteria", {3=>8, 4=>4}], 96=>["Bacteria", "Actinobacteria", "class_NA", {3=>2, 4=>2}], 137=>["Bacteria", "Proteobacteria", "Alphaproteobacteria", {3=>3}]}
    
    return taxon_strings_w_counts_per_d
  end
  
  def fill_zeros(cnts_per_dataset_ids_by_tax_ids)
    # puts "VVV: params[\"dataset_ids\"] = " + params["dataset_ids"].inspect
    # puts "VVV1: cnts_per_dataset_ids_by_tax_ids = " + cnts_per_dataset_ids_by_tax_ids.inspect
    params[:dataset_ids].each do |d_id|
      cnts_per_dataset_ids_by_tax_ids[d_id.to_i] = 0 unless cnts_per_dataset_ids_by_tax_ids[d_id.to_i].is_a? Numeric
    end
    # puts "WWW: cnts_per_dataset_ids_by_tax_ids = " + cnts_per_dataset_ids_by_tax_ids.inspect
    return cnts_per_dataset_ids_by_tax_ids
  end
 
  def create_taxonomy_w_counts_to_show(rank_number, my_pdrs)
    @taxonomies            = {}
    @dat_counts_seq_tax    = {}    
    
    tax_hash_obj           = TaxaCount.new    
    taxonomy_per_d = Hash.new
    result = Benchmark.measure do
      taxonomy_per_d         = get_taxonomy_per_d(my_pdrs, tax_hash_obj)
    end
    puts "get_taxonomy_per_d(my_pdrs, tax_hash_obj) result " + result.to_s
    
    # 1) make taxonomy_id strings from Taxonomy by rank
    # 2) get taxon names
    # 3) arrange by dataset_ids
    # 4) add counts to show in tax_table_view    
    taxonomy_by_t_id_upto_rank_obj = TaxonomyWNames.new
    taxonomy_by_t_id_upto_rank     = Hash.new
    result = Benchmark.measure do
      taxonomy_by_t_id_upto_rank = taxonomy_by_t_id_upto_rank_obj.create(rank_number, @taxonomies)
    end
    
    puts "taxon_strings_upto_rank_obj.create(rank_number, @taxonomies) result " + result.to_s
    
    result = Benchmark.measure do
      @@taxonomy_w_cnts_by_d = make_taxon_strings_w_counts_per_d(taxonomy_by_t_id_upto_rank, tax_hash_obj, taxonomy_per_d)
    end
    puts "make_taxon_strings_w_counts_per_d(taxonomy_by_t_id_upto_rank, tax_hash_obj, taxonomy_per_d) result " + result.to_s
    @@taxonomy_w_cnts_by_d
  end
end

class Hash
  def self.recursive
    new { |hash, key| hash[key] = recursive }
  end
end
