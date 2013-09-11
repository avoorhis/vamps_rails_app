class VisualizationController < ApplicationController
  
  before_filter :authenticate_user!
  

  def parse_view
    # TEST:
    @projects_test = ["SLM_NIH_Bv4v5"]
    @datasets_test = ["1St_156_Marathon", "1St_85_DELANO"]
    
    @myarray = get_test_matrix
      
    #@my_json = @myarray.to_json  

    
    @nas         = params[:nas]
    #domains  = Array[params[:bacteria], params[:archaea], params[:eukarya], params[:organelle], params[:unknown]]
    domains      = params[:domains]
    @domains     = domains.compact
    @tax_rank    = params[:tax_rank]
    @rank_number = get_rank_num()
    @view        = params[:view]
    # params[:datasets] are created in visualization.js::getDatasets()
    # session[:datasets]= clean_datasets( params[:datasets] )
    @datasets    = clean_datasets( params[:datasets] )

     puts @datasets
    # SLM_NIH_Bv4v5--1St_121_Stockton
    
    # TODO 
    #   1) dhtmltree takes project and dataset together into "params[:datasets]", no need to search for project
    #   2) it repeates project with each dataset
    #   3) if click on a project only - does not select the underliyng datasets
    #   4) it repeats "0" with each project/dataset
    #   e.g
    #     fromstandartTreeRow
    #      "datasets"=>"0;SLM_NIH_Bv4v5,
    #     0;SLM_NIH_Bv4v5;1St_121_Stockton,
    #     0;SLM_NIH_Bv4v5;1St_120_Richmond,
    
    @taxQuery    = create_tax_query()
    @result      = Project.find_by_sql(@taxQuery)
    taxonomy_by_site = {}    

    for res in @result
      pj  = res["project"]
      ds  = res["dataset"]
      pd = pj+'--'+ds
      ts  = res["taxonomy"]
      knt = res["seq_count"]
      if taxonomy_by_site.has_key?(ts) then
        # append
        taxonomy_by_site[ts].merge!(pd => knt)
      else
        # add array to hash
        taxonomy_by_site[ts] = {pd=>knt}
      end        
    end
    # sort taxonomically alpha
    puts taxonomy_by_site
    taxonomy_by_site = taxonomy_by_site.sort
      # change to array of hashes and fill in zeros
      @taxonomy_by_site = fill_in_zeros(taxonomy_by_site)
     #session[:taxonomy_by_site] = @taxonomy_by_site

  # select SQL_CACHE project_dataset, taxon_string, knt, classifier, frequency, dataset_count FROM new_summed_data_cube  
    # join new_project_dataset using(project_dataset_id)   
    # join new_taxon_string using(taxon_string_id, rank_number)  where
    # project_dataset in ('AB_SAND_Bv6--HS122','AB_SAND_Bv6--HS123') and  rank_number='1'
    
    if params[:view] == "heatmap"
      render :heatmap
    elsif  params[:view] == "bar_charts"
      render :bar_charts
    else params[:view] == "tax_table"
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
    @result = ActiveRecord::Base.connection.select_rows(sql)
    # puts "URA"
    # puts @result.inspect
    # puts @result[0][2] dataset_count
    # return @result
  end
    
  def create_comma_list(my_array)
    return "'" + my_array.join("', '") + "'"
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
    superkingdom  = {"archaea"=>1,"bacteria"=>2, "organelle"=>3,"unknown"=>4,"eukarya"=>5}
    sql_superkingdom = ''

    taxQuery = "SELECT project, dataset, seq_count, taxonomy from sequence_pdr_infos"
    join     = "  JOIN projects ON (project_id = projects.id)
                  JOIN datasets ON (dataset_id = datasets.id)
                  JOIN sequence_uniq_infos ON (sequence_uniq_infos.sequence_id = sequence_pdr_infos.sequence_id)
                  JOIN taxonomies ON (sequence_uniq_infos.taxonomy_id = taxonomies.id)"
    where    = "  where ( "
    projects_datasets.each do |pd|
      where    +=  "(project='#{pd[:project]}' and dataset='#{pd[:dataset]}') or "
                    
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

  def get_rank_num()
    tax_num = { "domain"=>0,"phylum"=>1,"class"=>2,"order"=>3,"family"=>4,"genus"=>5,"species"=>6,"strain"=>7 }
    return tax_num[@tax_rank]
  end

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
