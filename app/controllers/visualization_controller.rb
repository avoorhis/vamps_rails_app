class VisualizationController < ApplicationController
	
	before_filter :authenticate_user!
	

	def parse_view
	  @myarray = get_test_matrix
	    
	  #@my_json = @myarray.to_json	

	  
	  session[:nas] 	= params[:nas]
	  #domains	= Array[params[:bacteria], params[:archaea], params[:eukarya], params[:organelle], params[:unknown]]
	  domains 			= params[:domains]
	  session[:domains] = domains.compact
	  session[:tax_rank]= params[:tax_rank]
	  session[:rank_num]= get_rank_num()
	  session[:view] 	= params[:view]
	  # params[:datasets] are created in visualization.js::getDatasets()
	  session[:datasets]= clean_datasets( params[:datasets] )
      
      @taxQuery 		= create_tax_query()
	  

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

	private

	def create_tax_query()

	  sql_datasets 		= session[:datasets].join("','")
	  # superkingdoms has to match what is in db table
	  superkingdom	= {"archaea"=>1,"bacteria"=>2, "organelle"=>3,"unknown"=>4,"eukarya"=>5}
	  sql_superkingdom = ''

	  taxQuery = "select project_dataset, taxon_string, knt, sdc.classifier, frequency, dataset_count
	  FROM summed_data_cube as sdc"
	  join = " JOIN project_dataset using(project_dataset_id)
	  			JOIN taxon_string using(taxon_string_id, rank_number)"

	  where = " WHERE project_dataset in ('#{sql_datasets}')
	  			AND rank_number='#{session[:rank_num]}'"
	  ##DOMAINS
	  if session[:domains].length == 1 then
	  	join  += " JOIN taxonomies using(taxon_string_id)"
	  	where += " AND superkingdom_id='#{superkingdom[session[:domains][0]]}'"
	  elsif session[:domains].length == 5 then
	  	# nothing extra here
	  else 
	  	sk_num = []
	  	session[:domains].each do |d|
	  		sk_num << superkingdom[d].to_s()
	  	end
	  	sql_superkingdom_ids 		= sk_num.join("','")
	  	
	  	join  += " JOIN taxonomies using(taxon_string_id)"
	  	where += " AND superkingdom_id in ('#{sql_superkingdom_ids}')"
	  end
	  ##NAs
	  if session[:nas] == 'no' then
	  	# TODO
	  	# and  taxon_string not like 'no_%' 
        # and taxon_string not like 'NA%'
        # and taxon_string not like '%;NA;%'
        # and taxon_string not like '%;NA' 
        # and taxon_string not like '%_NA'
	  end

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
		return tax_num[session[:tax_rank]]
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
