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
    p_objs = get_choosen_projects()
    p_objs.each do |p_obj, d_arr|
      choosen_p_w_d            = Hash.new
      choosen_p_w_d[:pid]      = p_obj[:id]
      choosen_p_w_d[:pname]    = p_obj[:project]
      choosen_p_w_d[:datasets] = d_arr.select {|d| d.attributes[:id] if d_ids.include? d.attributes[:id].to_s}
      project_array << choosen_p_w_d
    end
    return project_array
  end
  
  def get_choosen_projects()
    datasets_by_project_all = make_datasets_by_project_hash()
    p_objs = datasets_by_project_all.select {|p_o| p_o.attributes[:id] if params[:project_ids].include? p_o.attributes[:id].to_s }
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
      if counts_per_dataset_id[d.attributes[:dataset_id]].nil? 
        counts_per_dataset_id[d.attributes[:dataset_id]] = d.attributes[:seq_count]
      else
        counts_per_dataset_id[d.attributes[:dataset_id]] += d.attributes[:seq_count]
      end
    end

    return counts_per_dataset_id
  end

  # todo: make one call!
  # Dataset Load (0.3ms)  SELECT `datasets`.* FROM `datasets`
  # Dataset Load (0.3ms)  SELECT `datasets`.* FROM `datasets` WHERE `datasets`.`id` IN (2, 3)
  #   
  
end