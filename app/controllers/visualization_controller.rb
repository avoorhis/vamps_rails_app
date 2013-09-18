class VisualizationController < ApplicationController
  
  before_filter :authenticate_user!
  

  def parse_view
    # TEST:
    
    @projects_test = %w[SLM_NIH_v3]
    @datasets_test = %w[7_Stockton 8_Stockton 9_Stockton]

    #@myarray = get_test_matrix
    

    we_have_some_data = false
    @master_sample_data = Hash.new
    @master_sample_data2 = []
    
    temp_project = {}
    params.each do |k,v|
      
      param_parts = k.split('--')
      #puts param_parts[0]
      # here we catch the selected project (the selected datasets should follow)
      # if no datasets folow then we should delete @master_sample_data[pid]
      if param_parts[1] == 'pj-id' and v.to_i > 0

         
         temp_project = { :id=>v.to_i, :name=>param_parts[0] }

      end
      if param_parts[1] == 'ds-ids' and params[k].any?
        if temp_project[:name] == param_parts[0]
          we_have_some_data = true
          puts temp_project.inspect
          v = v.collect{|i| i.to_i}
          @master_sample_data[temp_project[:id]] = v
          myhash = {:pid=>temp_project[:id], :name=>temp_project[:name],  :datasets=>v,}
          #myhash2 = {:pid=>temp_project[:id], :name=>temp_project[:name],  :datasets=>v,}
          @master_sample_data2.push(myhash)
          #@master_sample_names.push(myhash2)
          temp_project = {}
        end
      end
      # if no datasets folow then we should delete @master_sample_data[pid]
      #if @master_sample_data.include? temp_project[:id] and @master_sample_data[temp_project[:id]] == []
      #  @master_sample_data.delete(temp_project[:id])
      #end
    end
    if not we_have_some_data
      flash.alert = 'Choose some data!'
      redirect_to visualization_index_path
      return
    end
    puts 'Which is a better format: '
    puts '  this? a simple hash: ' + @master_sample_data.inspect
    puts '  Or this? an array of hashes: '+@master_sample_data2.inspect

    @nas         = params[:nas]
    #domains  = Array[params[:bacteria], params[:archaea], params[:eukarya], params[:organelle], params[:unknown]]
    domains      = params[:domains]
    @domains     = domains.compact
    # TODO: can we take a rank_id here, please?
    
    rank_id = params[:tax_id]
    puts 'this_rank id: '+rank_id.to_s
    this_rank = Rank.find_by_id(rank_id)
    @rank_number = this_rank.rank_number
    @rank_name = this_rank.rank
    puts 'this_rank num: '+@rank_number.to_s
    puts 'this_rank name: '+@rank_name 
    # @rank_number = get_rank_num()
    @view        = params[:view]
    # params[:datasets] are created in visualization.js::getDatasets()
    # session[:datasets]= clean_datasets( params[:datasets] )
    #@datasets    = clean_datasets( params[:datasets] )

    # SLM_NIH_Bv4v5--1St_121_Stockton
    
    # TODO 
    #   1) dhtmltree takes project and dataset together into "params[:datasets]", shouldn't it be separate params? 
    #   2) no need for Project.find_by_sql - we have it from params
    #   3) it repeates project with each dataset - better get it once
    #   4) if click on a project only - does not select the underliyng datasets
    #   5) it repeats "0" with each project/dataset - what this?
    #   e.g
    #     fromstandartTreeRow
    #      "datasets"=>"0;SLM_NIH_Bv4v5,
    #     0;SLM_NIH_Bv4v5;1St_121_Stockton,
    #     0;SLM_NIH_Bv4v5;1St_120_Richmond,
    
    @taxQuery    = create_tax_query()
    print @taxQuery
    result      = Project.find_by_sql(@taxQuery)
    @taxonomy_hash = create_sorted_taxonomy_by_site(result)
    puts "before fill with zeros:"
    puts @taxonomy_hash
    @taxonomy_by_site_hash = fill_in_zeros(@taxonomy_hash)
    puts "after fill with zeros:"
    puts @taxonomy_by_site_hash
    # puts 'EXIT'
    # @taxonomy_by_site_array = create_sorted_taxonomy_by_site(result)
    # puts @taxonomy_by_site_array.inspect
    # puts
    # # change to array of hashes and fill in zeros
    # @taxonomy_by_site_hash = fill_in_zeros(@taxonomy_by_site_array)
    # puts @taxonomy_by_site_hash.inspect

    #session[:taxonomy_by_site] = @taxonomy_by_site

  # # select SQL_CACHE project_dataset, taxon_string, knt, classifier, frequency, dataset_count FROM new_summed_data_cube  
  #   # join new_project_dataset using(project_dataset_id)   
  #   # join new_taxon_string using(taxon_string_id, rank_number)  where
  #   # project_dataset in ('AB_SAND_Bv6--HS122','AB_SAND_Bv6--HS123') and  rank_number='1'
    
    if params[:view]      == "heatmap"
      render :heatmap
    elsif  params[:view]  == "bar_charts"
      render :bar_charts
    else params[:view]    == "tax_table"
      #default
      render "tax_table"
    end    
  end

  def get_taxonomy_by_site
    return @taxonomy_by_site
  end
  
  def get_datasets
    return @datasets
  end

  def index
    @all_data = get_test_sample_object()
    @projects = Project.all    
  end

  def create

  end

  def show

  end

  def heatmap

  end

  def bar_chart

  end

  def tax_table

  end
  
################################################################################
  private

def create_sorted_taxonomy_by_site(result)
    taxonomy_hash =  {} 
    @project_datasets = {}
    for res in result
      pj  = res["project"]
      ds  = res["dataset"]
      #pd = pj+'--'+ds
      ts  = res["taxonomy"]
      knt = res["knt"]
      # create dataset names hash
      # PD: {"SLM_NIH_Bv6"=>["SS_WWTP_1_25_11_2step"], "SLM_NIH_Bv4v5"=>["1St_121_Stockton", "1St_120_Richmond", "1St_152_Metro_North"]}
      if @project_datasets.has_key?(pj) then
        if ! @project_datasets[pj].include?(ds) 
          @project_datasets[pj] << ds
        end
      else
        @project_datasets[pj] = [ds]
      end
      if taxonomy_hash.has_key?(ts) then
        if taxonomy_hash[ts].has_key?(pj) then
          if taxonomy_hash[ts][pj].has_key?(ds) then
            # sum knt for this ts, pj and ds
            taxonomy_hash[ts][pj][ds] += knt 
          else
            #new ds
            taxonomy_hash[ts][pj].merge!(ds=>knt) 
          end          

        else
          # new pj
          taxonomy_hash[ts].merge!(pj => {ds=>knt})
        end
      else
        # new tax: add new hash if not already there
        taxonomy_hash[ts] = {pj=>{ds=>knt}}
      end    
    end

    return taxonomy_hash
end
#
#  CREATE SORTED TAXONOMY BY SITE
#
# has all sites filled (with zeros if neccesary)
# {
#   "Bacteria;Bacteroidetes"=>
#     {
#       "SLM_NIH_Bv6"=>
#         { 
#           "SS_WWTP_1_25_11_2step"=>1011
          
#         },
#       "SLM_NIH_Bv4v5"=>
#         {
#           "1St_121_Stockton"=>0, 
#             "1St_120_Richmond"=>0, 
#             "1St_152_Metro_North"=>0
#         }
#     },
#   "Bacteria;Proteobacteria"=>{
#     "SLM_NIH_Bv6"=>
#       {
#         "SS_WWTP_1_25_11_2step"=>1634236
#       },
#     "SLM_NIH_Bv4v5"=>
#       {
#         "1St_121_Stockton"=>11, 
#         "1St_120_Richmond"=>4, 
#         "1St_152_Metro_North"=>1
#       }
#   }
# }
  # def create_sorted_taxonomy_by_site(result)
  #   taxonomy_by_site = {}  
  #   @project_datasets = {}
  #   for res in result
  #     pj  = res["project"]
  #     ds  = res["dataset"]
  #     pd = pj+'--'+ds
  #     ts  = res["taxonomy"]
  #     knt = res["knt"]

  #     # create dataset names hash
  #     # PD: {"SLM_NIH_Bv6"=>["SS_WWTP_1_25_11_2step"], "SLM_NIH_Bv4v5"=>["1St_121_Stockton", "1St_120_Richmond", "1St_152_Metro_North"]}
  #     if @project_datasets.has_key?(pj) then
  #       if ! @project_datasets[pj].include?(ds) 
  #         @project_datasets[pj] << ds
  #       end
  #     else
  #       @project_datasets[pj] = [ds]
  #     end
  #     if taxonomy_by_site.has_key?(ts) then
  #       if taxonomy_by_site[ts].has_key?(pd) then
  #         # sum knt for this ts and ds
  #         taxonomy_by_site[ts][pd] += knt 
  #       else
  #         # append new
  #         taxonomy_by_site[ts].merge!(pd => knt)
  #       end
  #     else
  #       # add new array to hash if not already there
  #       taxonomy_by_site[ts] = {pd=>knt}
  #     end        
  #   end
  #   # sort taxonomically alpha
  #   #puts 'PD: '+@project_datasets.inspect
  #   return taxonomy_by_site.sort
  # end

#
#  FILL IN ZEROS
#
  def fill_in_zeros(tax_hash)
    #new_tax_array = []
    tax_hash.each do |tax, pj_hash| 
      @project_datasets.each do |project,datasets| 
        if not pj_hash.include?(project) then
          # add the empty project
          pj_hash.merge!(project => {})
        end
      end

      pj_hash.each do |p, ds_hash|
        #puts 'ds_hash '+ds_hash.inspect
        @project_datasets.each do |project,datasets| 
          datasets.each do |dataset|
            
            #pd = project+'--'+dataset
            if p==project and not ds_hash.include?(dataset) then
            #tax_hash[tax].merge!(ds => 0)
            ds_hash.merge!(dataset => 0)

            end

          end
        end

      end
      #puts 'pj_hash '+pj_hash.inspect 
      #new_tax_array.push({:taxonomy=>tax,:datasets=>v})
    end
    return tax_hash
    #return new_tax_array
  end
  # def fill_in_zeros(tax_hash)
  #   #new_tax_array = []
  #   tax_hash.each do |tax, v|      
  #     @project_datasets.each do |project,datasets| 
  #       datasets.each do |dataset|

  #         pd = project+'--'+dataset
  #         if not v.include?(pd) then
  #           #tax_hash[tax].merge!(ds => 0)
  #           v.merge!(pd => 0)

  #         end

  #       end

  #     end
  #     #new_tax_array.push({:taxonomy=>tax,:datasets=>v})
  #   end
  #   return tax_hash
  #   #return new_tax_array
  # end

#
#  GET DATASET COUNTS
#
  def get_dataset_counts()
    
    sql = "SELECT datasets.project_id, dataset_id, sum(seq_count) FROM sequence_pdr_infos
      JOIN datasets ON (dataset_id = datasets.id)
      JOIN projects ON (project_id = projects.id)
      "      

    where    = "  WHERE (\n"
    @master_sample_data.each do |pid,d_array|       
         d_sql = create_comma_list(d_array)
         puts d_sql
           where    += "(projects.id = '#{pid}' "
           where    += "AND datasets.id IN (#{d_sql}) )\nOR "
    end 
    where = where[0..-4]
    where  += ")\n"    
    sql = sql + where + "
      GROUP BY datasets.project_id, dataset_id
    "
    puts sql
    result = ActiveRecord::Base.connection.select_rows(sql)
    return result
  end

#
#  CREATE COMMA LIST
#    
  def create_comma_list(my_array)
    return "'" + my_array.join("', '") + "'"
  end
  
  def make_taxa_by_rank()
    #rank_number = Rank.get_rank_number(@tax_rank)
    #puts 'rank id: '+rank_number  # == rank.id
  
    
    #rank_id_names = %w[superkingdom_id phylum_id klass_id order_id family_id genus_id species_id strain_id]
    rank_names        = %w[superkingdom  phylum  klass   order  family   genus  species strain ]
    taxon_table_names = %w[superkingdoms phylums klasses orders families genera species strains]
    rank_ids = ""
    taxa_joins = ""
    for n in 0..@rank_number 
      rank_ids += ' t'+(n+1).to_s+".#{rank_names[n]},"
      taxa_joins += "LEFT JOIN #{taxon_table_names[n]} AS t"+(n+1).to_s+" ON (#{rank_names[n]}_id = t"+(n+1).to_s+".id)\n"
    end
    
    return rank_ids[0..-2], taxa_joins
  end    

#
#  CREATE TAX QUERY
#
  def create_tax_query()
    

    get_dataset_counts()
 
    
    # superkingdoms has to match what is in db table
    # TODO: get it from db
    #superkingdom  = Taxon.find_by_rank(@tax_rank)
    # will this always be '10'?
    
    @superkingdom_list = Superkingdom.all
    # {"archaea"=>1,"bacteria"=>2, "organelle"=>3,"unknown"=>4,"eukarya"=>5}

    rank_ids, taxa_joins = make_taxa_by_rank()
    print "URA! rank_ids = #{rank_ids}\n taxa_joins = #{taxa_joins}"
    taxQuery = "SELECT distinct projects.project as project, datasets.dataset as dataset, CONCAT_WS(\";\", #{rank_ids}) AS taxonomy, seq_count AS knt, classifier
FROM sequence_pdr_infos"
join = "\nJOIN datasets ON (dataset_id = datasets.id)
JOIN projects ON (project_id = projects.id) 
JOIN sequence_uniq_infos USING(sequence_id)
JOIN taxonomies ON (taxonomies.id = taxonomy_id)
#{taxa_joins}
"

    where    = "  WHERE (\n"
    @master_sample_data.each do |pid,d_array|
        puts pid
        
         d_sql = create_comma_list(d_array)
         puts d_sql
           where    += "(projects.id = '#{pid}' "
           where    += "AND datasets.id IN (#{d_sql}) )\nOR "
    end 
    where = where[0..-4]
    where  += ")\n"           
    # calculate seq_count/dataset_count AS frequency, dataset_count

    ##DOMAINS
    unless @domains.length == 5 then
      
      sk_num = []
      @superkingdom_list.each do |sk|
          if @domains.include? sk.superkingdom then
            
              sk_num << sk.id.to_s
            
          end
      end 
      puts 'sk num '+sk_num.to_s    
      if @domains.length == 1

        where += " AND superkingdom_id ='#{sk_num[0]}'"
      else
        sql_superkingdom_ids     = sk_num.join("','")      
        where += " AND superkingdom_id in ('#{sql_superkingdom_ids}')"
    end
    end
    ##NAs
    if @nas == 'no' then
      # TODO
      # and  taxon_string not like 'no_%' 
        # and taxon_string not like 'NA%'
        # and taxon_string not like '%;NA;%'
        # and taxon_string not like '%;NA' 
        # and taxon_string not like '%_NA'
    end

    # there should be no GROUP BY or ORDER BY clause as it slows down the sql calls considerably
    # but the seq_count has to be summed for each unique: project,dataset,taxonomy
    group = "\nGROUP BY project, dataset, taxonomy"
   

    @taxQuery = taxQuery + join + where
  end

  def clean_datasets(ds_string)
    project_datasets_array = []

    # 0;AB_PRI_Ev9,0;AB_PRI_Ev9;PRI_0037,0;AB_PRI_Ev9;PRI_0038,0;AB_SAND_Bv6;HS122,0;AB_SAND_Bv6 
    # first split string on commas:
    pd_array = ds_string.split(',')
    # {0;AB_PRI_Ev9},{0;AB_PRI_Ev9;PRI_0037},{0;AB_PRI_Ev9;PRI_0038},{0;AB_SAND_Bv6;HS122},{0;AB_SAND_Bv6}
    # foreach split on semi-colon:
    pd_array.each do |dirty_pd|
      pd = dirty_pd.split(';')
      # if length of pd is 2 ignore it
      # else concat parts 2 and 3 and push onto array
      if pd.length == 3 then
        project_datasets_array << pd[1]+'--'+pd[2]
      end
    end
    return project_datasets_array

  end

  def get_test_sample_object
    


      all_sample_data = [
      {:id=>2, :name => 'BPC_MRB_C', :datasets =>
          [
            {:id=>1,:name=>'DS_1'},
            {:id=>16,:name=>'DS_2'},
            {:id=>34,:name=>'DS_3'}
          ]
        },
      {:id=>3, :name => 'KCK_MHB_Bv6', :datasets =>
        [
           {:id=>10,:name=>'DS_4'},
           {:id=>160,:name=>'DS_5'},
           {:id=>349,:name=>'DS_56'},
           {:id=>15,:name=>'DS_17'},
           {:id=>164,:name=>'DS_8'},
           {:id=>345,:name=>'DS_9'}
        ]
      },
      {:id=>5, :name => 'SLM_NIH_Bv6', :datasets => 
        [
          {:id=>25,:name=>'SS_WWTP_1_25_11_2step_2'},
          {:id=>123,:name=>'SS_WWTP_1_25_11_2step_123'},
          {:id=>56,:name=>'SS_WWTP_1_25_11_2step_56'}
        ]
      },
      {:id=>6, :name => 'SLM_NIH_Bv4v5', :datasets =>
        [
            {:id=>14,:name=>'DS_10'},
            {:id=>161,:name=>'DS_11'},
            {:id=>342,:name=>'DS_12'},
            {:id=>18,:name=>'DS_13'},
            {:id=>163,:name=>'DS_14'},
            {:id=>349,:name=>'DS_15'}
        ]
      } ]

  return all_sample_data

  end

  # def get_rank_num()
  #   tax_num = { "domain"=>0,"phylum"=>1,"class"=>2,"order"=>3,"family"=>4,"genus"=>5,"species"=>6,"strain"=>7 }
  #   return tax_num[@tax_rank]
  # end

  def get_test_matrix
    @myarray = []
    @myarray << {
      :taxonomy => "Archaea;Ancient_Archaeal_Group",
        :datasets =>
              {
                "HMP_AN_v1v3--103092734"=>3, 
                "HMP_AN_v1v3--147406386"=>34, 
                "HMP_AN_v1v3--158013734"=>2393, 
                "HMP_AN_v1v3--158114885"=>234, 
                "HMP_AN_v1v3--158276726"=>1
              }}

    @myarray << {
      :taxonomy => "Archaea;Crenarchaeota",
        :datasets =>
              {
                "HMP_AN_v1v3--103092734"=>1290, 
              "HMP_AN_v1v3--147406386"=>986, 
              "HMP_AN_v1v3--158013734"=>0, 
              "HMP_AN_v1v3--158114885"=>345, 
              "HMP_AN_v1v3--158276726"=>12
              }}
    @myarray << {
      :taxonomy => "Archaea;Korarchaeota",
        :datasets =>
              {
                "HMP_AN_v1v3--103092734"=>456, 
              "HMP_AN_v1v3--147406386"=>390, 
              "HMP_AN_v1v3--158013734"=>2, 
              "HMP_AN_v1v3--158114885"=>0, 
              "HMP_AN_v1v3--158276726"=>0
              }}
    @myarray << {
      :taxonomy => "Archaea;Marine_Hydrothermal_Vent_Group_2",
        :datasets =>
              {
                "HMP_AN_v1v3--103092734"=>0, 
              "HMP_AN_v1v3--147406386"=>2400, 
              "HMP_AN_v1v3--158013734"=>0, 
              "HMP_AN_v1v3--158114885"=>0, 
              "HMP_AN_v1v3--158276726"=>124
              }}

  end

end
