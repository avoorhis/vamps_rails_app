class VisualizationController < ApplicationController
  
  before_filter :authenticate_user!
  

  def parse_view
    # TEST:
    
    
    #@myarray = get_test_matrix
    
    #@my_json = @myarray.to_json  
    @nas         = params[:nas]
    #domains  = Array[params[:bacteria], params[:archaea], params[:eukarya], params[:organelle], params[:unknown]]
    domains      = params[:domains]
    @domains     = domains.compact
    # TODO: can we take a rank_id here, please?
    @tax_rank    = params[:tax_rank]
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
    
  #   @taxQuery    = create_tax_query()
  #   print @taxQuery
  #   # @result      = Project.find_by_sql(@taxQuery)
  #   taxonomy_by_site = {}    

  #   for res in @result
  #     pj  = res["project"]
  #     ds  = res["dataset"]
  #     pd = pj+'--'+ds
  #     ts  = res["taxonomy"]
  #     knt = res["seq_count"]
  #     if taxonomy_by_site.has_key?(ts) then
  #       # append
  #       taxonomy_by_site[ts].merge!(pd => knt)
  #     else
  #       # add array to hash
  #       taxonomy_by_site[ts] = {pd=>knt}
  #     end        
  #   end
  #   # sort taxonomically alpha
  #   puts taxonomy_by_site
  #   taxonomy_by_site = taxonomy_by_site.sort
  #     # change to array of hashes and fill in zeros
  #     @taxonomy_by_site = fill_in_zeros(taxonomy_by_site)
  #    #session[:taxonomy_by_site] = @taxonomy_by_site

  # # select SQL_CACHE project_dataset, taxon_string, knt, classifier, frequency, dataset_count FROM new_summed_data_cube  
  #   # join new_project_dataset using(project_dataset_id)   
  #   # join new_taxon_string using(taxon_string_id, rank_number)  where
  #   # project_dataset in ('AB_SAND_Bv6--HS122','AB_SAND_Bv6--HS123') and  rank_number='1'
    
  #   if params[:view] == "heatmap"
  #     render :heatmap
  #   elsif  params[:view] == "bar_charts"
  #     render :bar_charts
  #   else params[:view] == "tax_table"
  #     #default
  #     render "tax_table"
  #   end    
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

  

  def fill_in_zeros(tax_hash)
    new_tax_array = []
    tax_hash.each do |tax, v|      
      @datasets.each do |ds|
        if not v.include?(ds) then
          #tax_hash[tax].merge!(ds => 0)
          v.merge!(ds => 0)
        end
      end
      new_tax_array.push({:taxonomy=>tax,:datasets=>v})
    end
    #return tax_hash
    return new_tax_array
  end

  def get_dataset_counts()
    
    sql = "SELECT datasets.project_id, dataset_id, sum(seq_count) FROM sequence_pdr_infos
      JOIN projects ON (project_id = projects.id)
      JOIN datasets ON (dataset_id = datasets.id)
      WHERE project IN (#{create_comma_list(@projects_test)}) 
      AND   dataset IN (#{create_comma_list(@datasets_test)})  
      GROUP BY datasets.project_id, dataset_id
    "
    result = ActiveRecord::Base.connection.select_rows(sql)
    return result
  end
    
  def create_comma_list(my_array)
    return "'" + my_array.join("', '") + "'"
  end
  
  def make_taxa_by_rank()
    rank_id = Rank.find_by_rank(@tax_rank)
  
    # rank_ids = "superkingdom_id, phylum_id, class_id, orderx_id, family_id, genus_id, species_id, strain_id"
    rank_ids = "t1.taxon, t2.taxon, t3.taxon, t4.taxon, t5.taxon, t6.taxon, t7.taxon, t8.taxon"
    taxa_ids = "LEFT JOIN taxa AS t1 ON (superkingdom_id = t1.id)
    LEFT JOIN taxa AS t2 ON (phylum_id       = t2.id)
    LEFT JOIN taxa AS t3 ON (class_id        = t3.id)
    LEFT JOIN taxa AS t4 ON (orderx_id       = t4.id)
    LEFT JOIN taxa AS t5 ON (family_id       = t5.id)
    LEFT JOIN taxa AS t6 ON (genus_id        = t6.id)
    LEFT JOIN taxa AS t7 ON (species_id      = t7.id)
    LEFT JOIN taxa AS t8 ON (strain_id       = t8.id)
    "
    return rank_ids, taxa_ids
  end    
  
  def create_tax_query()
    projects_datasets = []
    
    #sql_project_datasets     = @datasets.join("','")
    @datasets.each do |pd|
      items = pd.split('--')
      projects_datasets.push({:project=>items[0],:dataset=>items[1]})
      
    end

    get_dataset_counts()
 
    
    # superkingdoms has to match what is in db table
    # TODO: get it from db
    superkingdom  = Taxon.find_by_rank(@tax_rank)
    
    # {"archaea"=>1,"bacteria"=>2, "organelle"=>3,"unknown"=>4,"eukarya"=>5}
    sql_superkingdom = ''

    rank_ids, taxa_ids = make_taxa_by_rank()
    print "URA! rank_ids = #{rank_ids}\n taxa_ids = #{taxa_ids}"
    taxQuery = "SELECT projects.project, datasets.dataset, CONCAT_WS(\";\", #{rank_ids}) AS taxonomy, seq_count AS knt, classifier
                  FROM sequence_pdr_infos
                  JOIN run_infos ON (run_infos.id = run_info_id)
                  JOIN sequence_uniq_infos USING(sequence_id)
                  JOIN taxonomies on (taxonomies.id = taxonomy_id)
                  #{taxa_ids}
                  JOIN projects ON(project_id = projects.id) 
                  JOIN datasets ON(dataset_id = datasets.id)
              "

    where    = "  WHERE project in (#{create_comma_list(@projects_test)}) 
                  AND dataset IN (#{create_comma_list(@datasets_test)})  
               "
                  
# calculate seq_count/dataset_count AS frequency, dataset_count

    ##DOMAINS
    if @domains.length == 1 then
      join  += "  JOIN taxonomies on(taxonomy_id = taxonomies.id)"
      where += "  AND superkingdom_id = '#{superkingdom[@domains[0]]}'"
    elsif @domains.length == 5 then
      # nothing extra here
    else 
      sk_num = []
      @domains.each do |d|
        sk_num << superkingdom[d].to_s()
      end
      sql_superkingdom_ids     = sk_num.join("','")
      
      join  += " JOIN taxonomies using(taxon_string_id)"
      where += " AND superkingdom_id in ('#{sql_superkingdom_ids}')"
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
    # remove last 'or'
    where = where[0..-4]
    where    +=  "  )
                and rank_id='#{@rank_number}'  "
   

    # taxQuery = "SELECT project, dataset, taxon_string, knt, sdc.classifier, frequency, dataset_count
    #               FROM summed_data_cube AS sdc"
    # join     = "  JOIN projects on(project_id = projects.id),
    #               JOIN datasets on(dataset_id = datasets.id)
    #           "

    # where    = "  WHERE project in ('#{sql_project}')
    #               AND dataset in ('#{sql_dataset}')
    #               AND rank_number='#{@rank_number}'"
    # ##DOMAINS
    # if @domains.length == 1 then
    #   join  += "  JOIN taxonomies on(taxonomy_id = taxonomies.id)"
    #   where += "  AND superkingdom_id = '#{superkingdom[@domains[0]]}'"
    # elsif @domains.length == 5 then
    #   # nothing extra here
    # else 
    #   sk_num = []
    #   @domains.each do |d|
    #     sk_num << superkingdom[d].to_s()
    #   end
    #   sql_superkingdom_ids     = sk_num.join("','")
      
    #   join  += " JOIN taxonomies using(taxon_string_id)"
    #   where += " AND superkingdom_id in ('#{sql_superkingdom_ids}')"
    # end
    # ##NAs
    # if @nas == 'no' then
    #   # TODO
    #   # and  taxon_string not like 'no_%' 
    #     # and taxon_string not like 'NA%'
    #     # and taxon_string not like '%;NA;%'
    #     # and taxon_string not like '%;NA' 
    #     # and taxon_string not like '%_NA'
    # end

    @taxQuery = taxQuery + where
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
