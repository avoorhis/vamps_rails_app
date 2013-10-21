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
    @taxonomy_w_cnts_by_d  = get_taxonomy_per_d(my_pdrs)
    
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
    puts "d_ids = " + d_ids.inspect
    d_ids = ["3", "4", "235", "236"]
     
    p_objs = get_choosen_projects()
    puts "p_objs = " + p_objs.inspect
    p_objs.each do |p_obj, d_arr|
      puts "\nURA1: p_obj: " + p_obj.inspect
      puts "\nURA2: d_arr: " + d_arr.inspect
      
      choosen_p_w_d            = Hash.new
      choosen_p_w_d[:pid]      = p_obj[:id]
      choosen_p_w_d[:pname]    = p_obj[:project]
      choosen_p_w_d[:datasets] = d_arr.select {|d| d[:id] if d_ids.include? d[:id].to_s}
      puts "\nURA20: choosen_p_w_d: " + choosen_p_w_d.inspect
      project_array << choosen_p_w_d
    end
    puts "project_array = " + project_array.inspect
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
  
  def make_taxa_string_by_rank(taxon_strings_per_d)
    rank = @rank_obj.rank_number + 1
    taxon_string_by_rank_per_d  = Hash.new{|hash, key| hash[key] = []}


    taxon_strings_per_d.each do |dataset_id, taxon_string_arr|
      taxon_string_arr.each do |taxon_string_orig|
        taxon_string_by_rank = taxon_string_orig.take(rank)
        # .join(";")
        # puts "UUU " + taxon_string_by_rank.inspect
        # puts "-" * 7
        taxon_string_by_rank_per_d[dataset_id] << taxon_string_by_rank
      end
    end
    puts "taxon_string_by_rank_per_d = " + taxon_string_by_rank_per_d.inspect
    puts "-" * 7
    # UUU {3=>["Bacteria;Proteobacteria;Gammaproteobacteria;Enterobacteriales;Enterobacteriaceae", "Bacteria;Actinobacteria;class_NA;Actinomycetales;Intrasporangiaceae", "Bacteria;Proteobacteria;Alphaproteobacteria;order_NA;family_NA"], 4=>["Bacteria;Proteobacteria;Gammaproteobacteria;Enterobacteriales;Enterobacteriaceae", "Bacteria;Actinobacteria;class_NA;Actinomycetales;Intrasporangiaceae"]}
    return taxon_string_by_rank_per_d
  end
  
end