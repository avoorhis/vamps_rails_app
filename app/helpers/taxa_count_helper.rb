module TaxaCountHelper
  def get_rank_names()
    ranks      = Rank.all.sorted 
    rank_names = []     
    ranks.map {|rank| rank.rank == "class" ? rank_names << "klass" : rank_names << rank.rank}
    rank_names.delete("NA")
    return rank_names
  end

  def get_taxonomy_per_d(my_pdrs, tax_hash_obj)

    dat_counts_seq = []
    result = Benchmark.measure do
      dat_counts_seq = create_dat_seq_cnts(my_pdrs)  
    end
    puts "create_dat_seq_cnts(my_pdrs)  result " + result.to_s
    
    # result = Benchmark.measure do
    #   all_seq_ui     = get_all_sequence_uniq_infos(dat_counts_seq.map { |u| u[:sequence_id] })
    # end
    # all_seq_ui     = get_all_sequence_uniq_infos(dat_counts_seq.map { |u| u[:sequence_id] })
    # puts "get_all_sequence_uniq_infos(dat_counts_seq.map { |u| u[:sequence_id] }) result " + result.to_s
    
    # result = Benchmark.measure do
    #   add_tax_id(dat_counts_seq, all_seq_ui)
    # end
    # puts "add_tax_id(dat_counts_seq, all_seq_ui) result " + result.to_s
      
    @dat_counts_seq_tax = dat_counts_seq
    
    result = Benchmark.measure do
      @taxonomies = get_taxonomies(dat_counts_seq)
    end
    puts "get_taxonomies(dat_counts_seq) result " + result.to_s

    # @taxonomies = taxonomies
    # puts "\nHHH: taxonomies = " + taxonomies.inspect

    tax_hash = {}
    result = Benchmark.measure do
      tax_hash     = tax_hash_obj.create(@taxonomies, dat_counts_seq)
    end
    puts "tax_hash_obj.create(taxonomies, dat_counts_seq) result " + result.to_s
      
    # puts "\nRES: tax_hash = " + tax_hash.inspect
    # RES: tax_hash = {2=>{3=>{3=>{16=>{18=>{129=>{129=>{4=>{:datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, :datasets_ids=>{3=>8, 4=>4}}, 5=>{65=>{129=>{129=>{129=>{4=>{:datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>3}}, :datasets_ids=>{3=>11, 4=>4}}, 4=>{32=>{5=>{52=>{76=>{129=>{4=>{:datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>2, 4=>2}}, :datasets_ids=>{3=>13, 4=>6}}}
    
    return tax_hash
    # uniq_seq_info_ids_per_d = get_uniq_seq_info_ids(seq_ids_n_cnt_per_d)
    # taxonomy_ids_per_d      = get_taxonomy_ids_per_d(uniq_seq_info_ids_per_d)
    # add_count_to_uniq_seq_info_ids_per_d(uniq_seq_info_ids_per_d, seq_ids_n_cnt_per_d)
    # 
    # taxonomy_per_d          = Hash.new{|hash, key| hash[key] = []}
    # taxonomy_ids_per_d.each do |dataset_id, v_arr|
    #     taxonomy_per_d[dataset_id] << Taxonomy.where(id: v_arr)
    # end
    # return taxonomy_per_d
  end

  def create_dat_seq_cnts(my_pdrs)
    puts "JJJ: my_pdrs = " + my_pdrs.inspect
    dat_seq_cnts = Array.new
    
    my_pdrs.each do |v|
      interm_hash = Hash.new
      interm_hash[:dataset_id]  = v[:dataset_id]
      interm_hash[:sequence_id] = v[:sequence_id]
      interm_hash[:seq_count]   = v[:seq_count]
      # puts "\nVVV1"
      # puts "v.sequence_uniq_info.taxonomy_id = " + v.sequence_uniq_info.taxonomy_id.inspect
      # puts "\nVVV2"
      # puts "SequenceUniqInfo.find(v[:sequence_id]).taxonomy_id = " + SequenceUniqInfo.find(v[:sequence_id]).taxonomy_id.inspect
      interm_hash[:taxonomy_id] = v.sequence_uniq_info.taxonomy_id
      # SequenceUniqInfo.find(v[:sequence_id]).taxonomy_id
      
      dat_seq_cnts << interm_hash
    end
    puts "\nJJJ2"
    
    return dat_seq_cnts
  end

  # def get_all_sequence_uniq_infos(seq_u_ids)
  #   SequenceUniqInfo.where(sequence_id: seq_u_ids.uniq)
  # end

  # def add_tax_id(dat_counts_seq, all_seq_ui)
  #   # puts "\nAAA: dat_counts_seq = " + dat_counts_seq.inspect
  #   # puts "\nall_seq_ui = "+ all_seq_ui.inspect
  #     all_seq_ui.each do |u| 
  #       # puts "\nOOO2 all_seq_ui.each = " + u.inspect
  #       dat_counts_seq.each do |i|
  #         # puts "\nOOO1 dat_counts_seq.each = " + i.inspect
  #       
  #       if (u.attributes["sequence_id"] == i[:sequence_id])
  #         # puts "\nOOO"
  #         # puts u.attributes["taxonomy_id"]
  #         i[:taxonomy_id] = u.attributes["taxonomy_id"]
  #       end
  #     end
  #     # i[:taxonomy_id] = all_seq_ui.select {|u| u.attributes["sequence_id"] == i[:sequence_id]}.map{|a| a.attributes["taxonomy_id"]}[0]
  #   end
  #   return dat_counts_seq
  # end

  def get_taxonomies(dat_counts_seq)
    tax_ids = dat_counts_seq.map{|i| i[:taxonomy_id]}
    Taxonomy.where(id: tax_ids.uniq)
  end
  
end

