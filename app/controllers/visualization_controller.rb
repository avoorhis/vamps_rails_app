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
    
    @rank_obj             = Rank.find(params[:tax_id])
    @choosen_projects_w_d = get_choosen_projects_w_d()
    my_pdrs               = SequencePdrInfo.where(dataset_id: params["dataset_ids"])
    @dat_counts           = get_counts_per_dataset_id(my_pdrs)
    @taxonomy_w_cnts_by_d = get_taxonomy_w_cnts_by_d()
    
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
      choosen_p_w_d[:datasets] = d_arr.select {|d| d.attributes["id"] if d_ids.include? d.attributes["id"].to_s}
      project_array << choosen_p_w_d
    end
    return project_array
  end
  
  def get_choosen_projects()
    datasets_by_project_all = make_datasets_by_project_hash()
    p_objs = datasets_by_project_all.select {|p_o| p_o.attributes["id"] if params[:project_ids].include? p_o.attributes["id"].to_s }
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
  
  def get_ranks()
    ranks      = Rank.all.sorted 
    rank_names = []     
    ranks.map {|rank| rank.rank == "class" ? rank_names << "klass" : rank_names << rank.rank}
    rank_names.delete("NA")
    return rank_names
  end

  def get_counts_per_dataset_id(my_pdrs)
    dat_count = Hash.new
    datasets_per_pr = get_choosen_datasets_per_pr() #TODO: move to the main
    puts "URA1, my_pdrs = " + my_pdrs.inspect
    choosen_p_w_d[:datasets] = my_pdrs.select {|i| i.attributes["id"] if d_ids.include? d.attributes["id"].to_s}
    
    datasets_per_pr.map {|d| sum = 0; my_pdrs.map {|pdr_o| pdr_o.map {|spi| sum += spi.seq_count}; dat_count[d.id] = sum }}
    puts "dat_count = " + dat_count.inspect
    return dat_count
  end

  def get_choosen_datasets_per_pr()
    Dataset.all.find(params[:dataset_ids])
  end

  def dataset_not_choosen()
    redirect_to visualization_index_path, :alert => 'Choose some data!'
  end
  
  def get_taxonomy_w_cnts_by_d()
    rank_names                  = get_rank_names()    
    taxonomy_per_d              = get_taxonomy_per_d()
    puts "taxonomy_per_d = " + taxonomy_per_d.inspect
    
  end

  # todo: from where this first call?
  #     SequencePdrInfo Load (0.2ms)  SELECT `sequence_pdr_infos`.* FROM `sequence_pdr_infos` WHERE `sequence_pdr_infos`.`dataset_id` = 241
  #     SequencePdrInfo Load (0.1ms)  SELECT `sequence_pdr_infos`.* FROM `sequence_pdr_infos` WHERE `sequence_pdr_infos`.`dataset_id` = 242
  #     SequencePdrInfo Load (0.2ms)  SELECT `sequence_pdr_infos`.* FROM `sequence_pdr_infos` WHERE `sequence_pdr_infos`.`dataset_id` = 243
  #   dat_count = {241=>0, 242=>0, 243=>0}
  #     Rank Load (0.2ms)  SELECT `ranks`.* FROM `ranks` ORDER BY `ranks`.rank_number ASC
  #     SequencePdrInfo Load (0.3ms)  SELECT `sequence_pdr_infos`.* FROM `sequence_pdr_infos` WHERE `sequence_pdr_infos`.`dataset_id` IN (241, 242, 243)
  #   
  
end