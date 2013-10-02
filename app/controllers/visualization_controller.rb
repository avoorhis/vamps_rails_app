class VisualizationController < ApplicationController
  
  before_filter :authenticate_user!
  require 'benchmark'  
  
  def parse_view
    # TEST:    
    @ordered_projects, @ordered_datasets = create_ordered_datasets() 

    puts 'ordered projects: ' +@ordered_projects.inspect
    puts 'ordered datasets: ' +@ordered_datasets.inspect
    #puts 'ordered datasets list: ' +@ds_id_list.inspect
    if not @ordered_datasets.any?
      flash.alert = 'Choose some data!'
      redirect_to visualization_index_path
      return
    end
    #puts 'Which is a better format: '
    #puts '  this? a simple hash: ' + @master_sample_data.inspect
    #puts '  Or this? an array of hashes: '+@master_sample_data2.inspect

    @nas         = params[:nas]
    #domains  = Array[params[:bacteria], params[:archaea], params[:eukarya], params[:organelle], params[:unknown]]
    domains      = params[:domains]
    @domains     = domains.compact
    
    rank_id = params[:tax_id]
    rank_obj = Rank.find(rank_id)
    @rank_number = rank_obj.rank_number
    @rank_name   = rank_obj.rank
    
    @view        = params[:view]
    # params[:datasets] are created in visualization.js::getDatasets()
    # session[:datasets]= clean_datasets( params[:datasets] )
    #@datasets    = clean_datasets( params[:datasets] )

    # SLM_NIH_Bv4v5--1St_121_Stockton
    

    # sql version:
    #@taxQuery    = create_tax_query()
    #sql_result      = Project.find_by_sql(@taxQuery)
    #taxonomy_hash = create_sorted_taxonomy_by_site(sql_result)

    
    # this seems slow to me:
    #taxonomy_hash = get_data_using_rails_object()
    @new_taxonomy_hash = get_data_using_rails_object3()
    puts @new_taxonomy_hash
    #puts "NEW TAX "+new_tax.inspect
    #puts "before fill with zeros:"
    #puts "OLD TAX "+taxonomy_hash.inspect
    @taxonomy_by_site_hash = fill_in_zeros(@new_taxonomy_hash)
    #puts "after fill with zeros:"
    #puts @taxonomy_by_site_hash
  

    if params[:view]      == "heatmap"
      render :heatmap
    elsif  params[:view]  == "bar_charts"
      render :bar_charts
    else params[:view]    == "tax_table"
      #default
      render "tax_table"
    end    
  end

  # def get_taxonomy_by_site
  #   return @taxonomy_by_site
  # end
  
  # def get_datasets
  #   @datasets_per_pr = Dataset.find(params[:dataset_ids])
  #   return @datasets
  # end
  
  def make_datasets_by_project_hash()
    projects = Project.all    
    datasets = Dataset.all        
    datasets_by_project = Hash.new
    projects.each do |p|
      datasets_by_project[p] = datasets.select{|d| d.project_id == p.id}
    end
    return datasets_by_project
  end

  def index
    @all_data = get_test_sample_object()
    @datasets_by_project = make_datasets_by_project_hash()
    @domains  = Domain.all
    @ranks    = Rank.all.sorted    
  end

  # def create
  # 
  # end
  # 
  # def show
  # 
  # end
  
################################################################################
  private


#
#
#

def get_seq_ids()
  my_pdrs = SequencePdrInfo.where(dataset_id: params["dataset_ids"])

  seq_ids_per_d = Hash.new{|hash, key| hash[key] = []}
  my_pdrs.each do |pdr|
      seq_ids_per_d[pdr.dataset_id] << pdr.sequence_id
  end
  return seq_ids_per_d
end

def get_uniq_seq_info_ids(seq_ids_per_d)
  uniq_seq_info_ids_per_d = Hash.new{|hash, key| hash[key] = []}
  seq_ids_per_d.each do |dataset_id, seq_id_arr|
      uniq_seq_info_ids_per_d[dataset_id] << SequenceUniqInfo.where(sequence_id: seq_id_arr)
  end
  return uniq_seq_info_ids_per_d
end

def get_taxonomy_ids_per_d(uniq_seq_info_ids_per_d) 
  taxonomy_ids_per_d = Hash.new{|hash, key| hash[key] = []}
  uniq_seq_info_ids_per_d.each do |dataset_id, usi|
    usi.each do |us|
      us.each do |u|
        taxonomy_ids_per_d[dataset_id] << u.taxonomy_id
      end
    end
  end  
  return taxonomy_ids_per_d
end

def get_taxonomy_per_d()
  seq_ids_per_d           = get_seq_ids()  
  uniq_seq_info_ids_per_d = get_uniq_seq_info_ids(seq_ids_per_d)
  taxonomy_ids_per_d      = get_taxonomy_ids_per_d(uniq_seq_info_ids_per_d)
  
  taxonomy_per_d          = Hash.new{|hash, key| hash[key] = []}
  taxonomy_ids_per_d.each do |dataset_id, v_arr|
      taxonomy_per_d[dataset_id] << Taxonomy.where(id: v_arr)
  end
  return taxonomy_per_d
end

def get_ranks()
  ranks      = Rank.all.sorted 
  rank_names = []     
  ranks.map {|rank| rank.rank == "class" ? rank_names << "klass" : rank_names << rank.rank}
  rank_names.delete("NA")
  return rank_names
end

def get_all_taxa(rank_names)
  all_taxa   = Hash.new{|hash, key| hash[key] = []}
  rank_names.each do |rank_name|
    all_taxa[rank_name] = rank_name.camelize.constantize.all
  end
  return all_taxa
end  



def get_taxa_array(taxonomy, rank_name, all_taxa)
  id_name = rank_name + "_id"  
  taxon_arr  = []
  
  taxonomy.attributes.each  do |k, val|
    if (k == id_name)
      # puts all_taxa[rank_name].inspect
      res   = all_taxa[rank_name].select{|t| t.id == val}  
      taxon = res[0][rank_name]
      taxon_arr << taxon
      # ["Bacteria", "Firmicutes", "Bacilli", "Lactobacillales", "Streptococcaceae", "Streptococcus", "", "strain_NA"]
    end
  end
  return taxon_arr
end

def get_taxa_array1(taxonomy, rank_name, all_taxa)
  id_name = rank_name + "_id"  
  taxon_arr  = []
  
  tax_id_val = taxonomy.attributes[id_name]
  # puts "URA5 " + tax_id_val.inspect
  res   = all_taxa[rank_name].select{|t| t.id == tax_id_val}  
  taxon = res[0][rank_name]
  taxon_arr << taxon
  
  return taxon_arr
end


def make_taxa_string()
  taxon_arr  = []
  rank_names = get_ranks()  
  all_taxa   = get_all_taxa(rank_names)
  taxonomy   = Taxonomy.find(81) #todo: take from taxonomy_per_d by loop
  # puts "URA7" + all_taxa.inspect
  rank_names.each do |rank_name|
    (1..10).each do
      result = Benchmark.measure do
        taxon_arr = get_taxa_array(taxonomy, rank_name, all_taxa)
      end
      puts "result a loop " + result.to_s

      result1 = Benchmark.measure do
        taxon_arr = get_taxa_array1(taxonomy, rank_name, all_taxa)
      end
      puts "result no loop " + result1.to_s 
      puts "-" * 10
    end

  end
  # puts taxon_arr.inspect
  puts "HERE2" + taxon_arr.inspect
  puts "=" * 10
  
  # datasets.select{|d| d.project_id == p.id}
  
  #<Taxonomy id: 81, domain_id: 2, phylum_id: 2, klass_id: 2, order_id: 9, family_id: 40, genus_id: 46, species_id: 1, strain_id: 4, created_at: "2013-08-19 12:44:13", updated_at: "2013-08-19 12:44:13">
  
end

def make_taxa_string_by_rank()
  
end

def make_taxa_strings_per_d()
  
end


def get_data_using_rails_object3()
  taxonomy_hash  = {} 
  taxonomy_per_d = get_taxonomy_per_d()
  # all_taxa       = get_all_taxa()
  
  make_taxa_string()
  # puts "URA55" + all_taxa.inspect
  # domain"=>#<ActiveRecord::Relation [#<Domain id: 1, domain: "Archaea">, #<Domain id: 2, domain: "Bacteria">, #<Domain id: 5, domain: "Eukarya">, #<Domain id: 3, domain: "Organelle">, #<Domain id: 4, domain: "Unknown">]>, "phylum"=>#<ActiveRecord::Relation [#<Phylum id: 4, phylum: "Actinobacteria">
  # taxonomy_per_d:
  # URA55{2=>[#<ActiveRecord::Relation [#<Taxonomy id: 81, domain_id: 2, phylum_id: 2, klass_id: 2, order_id: 9, family_id: 40, genus_id: 46, species_id: 1, strain_id: 4, created_at: "2013-08-19 12:44:13", updated_at: "2013-08-19 12:44:13">, #<Taxonomy id: 82, domain_id: 2, phylum_id: 3, klass_id: 3, order_id: 16, family_id: 18, genus_id: 129, species_id: 1, strain_id: 4, created_at: "2013-08-19 12:44:13", updated_at: "2013-08-19 12:44:13">, #<Taxonomy id: 83, domain_id: 2, phylum_id: 3, klass_id: 3, order_id: 24, family_id: 64, genus_id: 92, species_id: 1, strain_id: 4, created_at: "2013-08-19 12:44:13", updated_at: "2013-08-19 12:44:13">, #<Taxonomy id: 84, domain_id: 2, phylum_id: 3, klass_id: 3, order_id: 21, family_id: 28, genus_id: 27, species_id: 1, strain_id: 4, created_at: "2013-08-19 12:44:13", updated_at: "2013-08-19 12:44:13">, #<Taxonomy id: 85, domain_id: 2, phylum_id: 3, klass_id: 4, order_id: 7, family_id: 7, genus_id: 38, species_id: 1, strain_id: 4, created_at: "2013-08-19 12:44:13", updated_at: "2013-08-19 12:44:13">, #<Taxonomy id: 86, domain_id: 2, phylum_id: 4, klass_id: 32, order_id: 5, family_id: 5, genus_id: 39, species_id: 1, strain_id: 4, created_at: "2013-08-19 12:44:13", updated_at: "2013-08-19 12:44:13">, #<Taxonomy id: 87, domain_id: 2, phylum_id: 3, klass_id: 5, order_id: 22, family_id: 29, genus_id: 129, species_id: 1, strain_id: 4, created_at: "2013-08-19 12:44:13", updated_at: "2013-08-19 12:44:13">, #<Taxonomy id: 88, domain_id: 2, phylum_id: 3, klass_id: 5, order_id: 6, family_id: 27, genus_id: 26, species_id: 1, strain_id: 4, created_at: "2013-08-19 12:44:13", updated_at: "2013-08-19 12:44:13">, #<Taxonomy id: 89, domain_id: 2, phylum_id: 3, klass_id: 4, order_id: 7, family_id: 7, genus_id: 129, species_id: 1, strain_id: 4, created_at: "2013-08-19 12:44:13", updated_at: "2013-08-19 12:44:13">, #<Taxonomy id: 90, domain_id: 2, phylum_id: 4, klass_id: 32, order_id: 5, family_id: 13, genus_id: 13, species_id: 1, strain_id: 4, created_at: "2013-08-19 12:44:13", updated_at: "2013-08-19 12:44:13">, ...]>]}

  # TODO: Andy, could we please use dataset_id in the new taxa hash? We can connect it with dataset/project names in a separate hash to show in a view, by calling the ids
  all_taxonomy.each do |did, tax_obj_list|
      # ds=Dataset.find(did)
      # dataset_name = ds.dataset
      # project_name = ds.project.project
      tax_string = ''
      count      = 10
      tax_obj_list.each do |t|
        tax_string = [
                       t[0].domain.domain,  t[0].phylum.phylum,
                       t[0].klass.klass,    t[0].order.order,
                       t[0].family.family,  t[0].genus.genus,
                       t[0].species.species,t[0].strain.strain
                      ].take(@rank_number+1).join(';')
        puts 'tax_string: '+tax_string
      end

      if taxonomy_hash.has_key?(tax_string) then
        if taxonomy_hash[tax_string].has_key?(project_name) then
          if taxonomy_hash[tax_string][project_name].has_key?(dataset_name) then
            # sum knt for this ts, pj and ds
            taxonomy_hash[tax_string][project_name][dataset_name] += count 
          else
            #new ds
            taxonomy_hash[tax_string][project_name].merge!(dataset_name=>count) 
          end   
        else
          # new pj
          taxonomy_hash[tax_string].merge!(project_name => {dataset_name=>count})
        end
      else
        # new tax: add new hash if not already there
        taxonomy_hash[tax_string] = {project_name=>{dataset_name=>count}}
      end 

  end
  puts taxonomy_hash.inspect
  return all_taxonomy
end

# def get_data_using_rails_object2()
# 
#   ds_ids = ['108', '109', '110', '111', '112', '113', '114', '115', '116', '117']
#   ds_ids = params['dataset_ids']
#   seq_ids     = SequencePdrInfo.find_all_by_dataset_id(ds_ids).map(&:sequence_id)
#   uniques_obj = SequenceUniqInfo.find_all_by_sequence_id(seq_ids)
#   tax_ids     = SequenceUniqInfo.find_all_by_sequence_id(seq_ids).map(&:taxonomy_id)
#   tax_objs = Taxonomy.find_all_by_id(tax_ids)
# end

def get_counts_per_dataset_id()
  dat_count = Hash.new
  @datasets_per_pr.map {|d| sum = 0; d.sequence_pdr_infos.map {|spi| sum += spi.seq_count}; dat_count[d.id] = sum }
  return dat_count

end

# def get_data_using_rails_object()
# 
#   taxonomy_hash =  {} 
#   # make this a list of strings so we can use eval() on later
#   taxa = 
#         [
#           "uniq.taxonomy.domain[:domain]",
#           "uniq.taxonomy.phylum[:phylum]",
#           "uniq.taxonomy.klass[:klass]",
#           "uniq.taxonomy.order[:order]",
#           "uniq.taxonomy.family[:family]",
#           "uniq.taxonomy.genus[:genus]",
#           "uniq.taxonomy.species[:species]",
#           "uniq.taxonomy.strain[:strain]"
#         ]
#   #did_array = @ordered_datasets.map { |x| x[:did] }
#   #puts did_array
#   # d_sql = create_comma_list(params['dataset_ids'])
#   # @my_pdrs = SequencePdrInfo.where "dataset_id in(#{d_sql})"
#   @my_pdrs = SequencePdrInfo.where(dataset_id: params["dataset_ids"])
#   
#   @my_pdrs.each do |pdr|
# 
#     dataset_id = pdr.dataset_id
#     # project_name = pdr.dataset.project[:project]
#     # to get_counts_per_dataset_id method above
#     # count = pdr[:seq_count]
# 
#     puts pdr[:sequence_id]
#     uniq = SequenceUniqInfo.find_by_sequence_id(pdr[:sequence_id])
# 
#     puts uniq
#     tax_string =""
#     unless uniq.taxonomy.nil?
# 
#       # create taxonomy string based on @rank_number
#       #tax_string = taxa.take(@rank_number+1).join(';')
#       tax_string = taxa.take(@rank_number+1).map!{ |x| eval(x) }.join(';')
#       
# 
#       if taxonomy_hash.has_key?(tax_string) then
#         if taxonomy_hash[tax_string].has_key?(project_name) then
#           if taxonomy_hash[tax_string][project_name].has_key?(dataset_id) then
#             # sum knt for this ts, pj and ds
#             taxonomy_hash[tax_string][project_name][dataset_id] += count 
#           else
#             #new ds
#             taxonomy_hash[tax_string][project_name].merge!(dataset_id=>count) 
#           end   
#         else
#           # new pj
#           taxonomy_hash[tax_string].merge!(project_name => {genus=>count})
#         end
#       else
#         # new tax: add new hash if not already there
#         taxonomy_hash[tax_string] = {project_name=>{genus=>count}}
#       end 
#     end 
# 
#   end
#   return taxonomy_hash
# 
# end

#
#  GET ORDERED DATASETS
# Andy, why do we need it?
def create_ordered_datasets() 
  # gets an ordered array of datasets:  
  # dataset_array:  [{:did=>did, :dname=>"dname"},{:did=>did, :dname=>"dname"}}

  # project_array:
  # Retains order: [  {:pid=>pid, :pname=>"pname", :datasets=>[{:did=>did_1,:dname=>"dname_1"},{}] }, 
  #                   {}
  #                   {} 
  #                 ]

  
  project_array = []
  temp_dataset_array = []
  dataset_array = []
  ds_id_list = []
  pid = -1  #initialize
  project_name = ''
  #params.each do |key,value|
  #ds_id_list = params['dataset_ids']
  params['dataset_ids'].each do |did|
    
    dataset = Dataset.find_by_id(did)
    

    dataset_name = dataset[:dataset]
    #puts project_name+' + '+dataset_name
    #temp_dataset_array << {:did=>did,:dname=>dataset_name}
    dataset_array << {:did=>did,:dname=>dataset_name}  
    

    project_name = dataset.project[:project]
    pid = dataset.project_id

    if index = project_array.find_index {|b| b[:pid] == pid} then
      project_array[index][:datasets] << {:did=>did,:dname=>dataset_name}
    else
      project_array << {:pid=>pid,:pname=>project_name, :datasets=>[{:did=>did,:dname=>dataset_name}]  }
    end


    
  end


  return project_array, dataset_array
end

#
#  CREATE SORTED TAXONOMY BY SITE
#
# def create_sorted_taxonomy_by_site(result)
#     taxonomy_hash =  {} 
#     
#     for res in result
#       pj  = res["project"]
#       ds  = res["dataset"]
#       #pd = pj+'--'+ds
#       ts  = res["taxonomy"]
#       knt = res["knt"]
#       
#       if taxonomy_hash.has_key?(ts) then
#         if taxonomy_hash[ts].has_key?(pj) then
#           if taxonomy_hash[ts][pj].has_key?(ds) then
#             # sum knt for this ts, pj and ds
#             taxonomy_hash[ts][pj][ds] += knt 
#           else
#             #new ds
#             taxonomy_hash[ts][pj].merge!(ds=>knt) 
#           end          
# 
#         else
#           # new pj
#           taxonomy_hash[ts].merge!(pj => {ds=>knt})
#         end
#       else
#         # new tax: add new hash if not already there
#         taxonomy_hash[ts] = {pj=>{ds=>knt}}
#       end    
#     end
# 
#     return taxonomy_hash
# end

#
#  FILL IN ZEROS
#
  def fill_in_zeros(tax_hash)

    tax_hash.each do |tax, pj_hash| 
      @ordered_projects.each do |pj| 
        if not pj_hash.include?(pj[:pname]) then
          # add the empty project
          pj_hash.merge!(pj[:pname] => {})
        end
      end

      pj_hash.each do |p, ds_hash|
        #puts 'ds_hash '+ds_hash.inspect
        @ordered_projects.each do |pj| 
          
          pj[:datasets].each do |ds|
            
            if p==pj[:pname] and not ds_hash.include?(ds[:dname]) then    
              ds_hash.merge!(ds[:dname] => 0)
            end
          end
        end

      end
      #puts 'pj_hash '+pj_hash.inspect 
    end
    return tax_hash
  end
 
#
#  GET DATASET COUNTS
#
  def get_dataset_counts()
    # TODO: Move to the model and simplify
    dataset_counts = Hash.new
    d_ids = [5,6,7] #TODO: take the ids from params[:dataset] and move to the main
    @datasets_per_pr = Dataset.all.find(d_ids) #TODO: move to the main
    @datasets_per_pr.each do |dataset|
      sum = 0
      dataset.sequence_pdr_infos.each do |i|
        sum += i.seq_count
      end
      dataset_counts[dataset[:id]] = sum
    end
    
    puts "get_dataset_counts = "
    puts dataset_counts.inspect
    
    return dataset_counts
    
    # sql = "SELECT datasets.project_id, dataset_id, sum(seq_count) FROM sequence_pdr_infos
    #   JOIN datasets ON (dataset_id = datasets.id)
    #   JOIN projects ON (project_id = projects.id)
    #   "      
    # 
    # where    = "  WHERE (\n"
    # #@master_sample_data.each do |pid,d_array|  
    # @ordered_datasets.each do |p|     
    #      
    #     # p[:datasets]
    #     d_array = p[:datasets].map { |x| x[:did] }
    #     puts d_array
    #     d_sql = create_comma_list(d_array)
    #     where    += "(projects.id = '#{p[:pid]}' "
    #     where    += "AND datasets.id IN (#{d_sql}) )\nOR "
    # end 
    # where = where[0..-4]
    # where  += ")\n"    
    # sql = sql + where + "
    #   GROUP BY datasets.project_id, dataset_id
    # "
    # puts sql
    # result = ActiveRecord::Base.connection.select_rows(sql)
    # puts "get_dataset_counts = "
    # puts result.inspect
    # return result
  end

#
#  CREATE COMMA LIST
#    
  def create_comma_list(my_array)
    return "'" + my_array.join("', '") + "'"
  end
  
  def make_taxa_by_rank()
    #rank_number = Rank.get_rank_number(@tax_rank)
    #rank_number = Rank.find(@tax_rank).rank_number
  
    #puts 'rank id: '+rank_number  # == rank.id
  
    

    #rank_id_names = %w[domain_id phylum_id klass_id order_id family_id genus_id species_id strain_id]
    rank_names        = %w[domain  phylum  klass   order  family   genus  species strain ]
    taxon_table_names = %w[domains phylums klasses orders families genera species strains]
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
#   def create_tax_query()
#     
# 
#     get_dataset_counts()
#     
#     rank_ids, taxa_joins = make_taxa_by_rank()
#     print "URA! rank_ids = #{rank_ids}\n taxa_joins = #{taxa_joins}"
#     taxQuery = "SELECT distinct projects.project as project, datasets.dataset as dataset, CONCAT_WS(\";\", #{rank_ids}) AS taxonomy, seq_count AS knt, classifier
# FROM sequence_pdr_infos"
# join = "\nJOIN datasets ON (dataset_id = datasets.id)
# JOIN projects ON (project_id = projects.id) 
# JOIN sequence_uniq_infos USING(sequence_id)
# JOIN taxonomies ON (taxonomies.id = taxonomy_id)
# #{taxa_joins}
# "
# 
#     where    = "  WHERE \n"
#     
#     did_array = @ordered_datasets.map { |x| x[:did] }
#     #puts did_array
#     d_sql = create_comma_list(did_array)
#     where    += "datasets.id IN (#{d_sql})\n "
#     
# 
#     ##DOMAINS
#     unless @domains.length == 5 then
#       
#       sk_num = []
#       @domains.each do |sk|
#           if @domains.include? sk.domain then
#             
#               sk_num << sk.id.to_s
#             
#           end
#       end 
#       puts 'sk num '+sk_num.to_s    
#       if @domains.length == 1
#         where += " AND domain_id ='#{sk_num[0]}'"
#       else
#         sql_domain_ids     = sk_num.join("','")      
#         where += " AND domain_id in ('#{sql_domain_ids}')"
#     end
#     end
#     ##NAs
#     if @nas == 'no' then
#       # TODO
#       where += " AND taxonomy not like 'no_%'"
#       where += " AND taxonomy not like 'NA%'"
#       where += " AND taxonomy not like '%;NA;%'"
#       where += " AND taxonomy not like '%;NA'" 
#       where += " AND taxonomy not like '%_NA'"
#     end
# 
#     # there should be no GROUP BY or ORDER BY clause as it slows down the sql calls considerably
#     # but the seq_count has to be summed for each unique: project,dataset,taxonomy
#     group = "\nGROUP BY project, dataset, taxonomy"
#    
# 
#     @taxQuery = taxQuery + join + where
#   end

  # def clean_datasets(ds_string)
  #   project_datasets_array = []
  # 
  #   # 0;AB_PRI_Ev9,0;AB_PRI_Ev9;PRI_0037,0;AB_PRI_Ev9;PRI_0038,0;AB_SAND_Bv6;HS122,0;AB_SAND_Bv6 
  #   # first split string on commas:
  #   pd_array = ds_string.split(',')
  #   # {0;AB_PRI_Ev9},{0;AB_PRI_Ev9;PRI_0037},{0;AB_PRI_Ev9;PRI_0038},{0;AB_SAND_Bv6;HS122},{0;AB_SAND_Bv6}
  #   # foreach split on semi-colon:
  #   pd_array.each do |dirty_pd|
  #     pd = dirty_pd.split(';')
  #     # if length of pd is 2 ignore it
  #     # else concat parts 2 and 3 and push onto array
  #     if pd.length == 3 then
  #       project_datasets_array << pd[1]+'--'+pd[2]
  #     end
  #   end
  #   return project_datasets_array
  # 
  # end

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
