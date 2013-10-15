module TaxaCountHelper
  def get_rank_names()
    ranks      = Rank.all.sorted 
    rank_names = []     
    ranks.map {|rank| rank.rank == "class" ? rank_names << "klass" : rank_names << rank.rank}
    rank_names.delete("NA")
    return rank_names
  end

  def get_taxonomy_per_d(my_pdrs)
    puts "URA3 = my_pdrs: " + my_pdrs.inspect
    dat_counts_seq = create_dat_seq_cnts(my_pdrs)
    puts "URA32 = dat_counts_seq: " + dat_counts_seq.inspect
    seq_u_ids = dat_counts_seq.map { |u| u[:sequence_id] }
    # taglist.select { |x| x[:name] == 'fine' }.map { |u| u[:tag] }
    
    puts "URA31 = seq_u_ids: " + seq_u_ids.inspect
    # p_objs = datasets_by_project_all.select {|p_o| p_o.attributes[:id] if p_ids.include? p_o.attributes[:id].to_s }
    
    # get_all_sequence_uniq_infos()
    all_seq_ui = SequenceUniqInfo.where(sequence_id: seq_u_ids)
    puts "all_seq_ui = " + all_seq_ui.inspect
    
    dat_counts_seq.each do |i|
      i[:taxonomy_id] = all_seq_ui.select {|u| u.attributes["sequence_id"] == i[:sequence_id]}.map{|a| a.attributes["taxonomy_id"]}[0]
    end
    puts "URA323 = dat_counts_seq: " + dat_counts_seq.inspect
    
    # p ary.find { |h| h['product'] == 'bcx' }['href']
    
     # u.attributes[:taxonomy_id]
    # { |h| h['product'] == 'bcx' }['href']
    # uniq_seq_info_ids_per_d = get_uniq_seq_info_ids(seq_ids_n_cnt_per_d)
    # taxonomy_ids_per_d      = get_taxonomy_ids_per_d(uniq_seq_info_ids_per_d)
    # add_count_to_uniq_seq_info_ids_per_d(uniq_seq_info_ids_per_d, seq_ids_n_cnt_per_d)
    # 
    # taxonomy_per_d          = Hash.new{|hash, key| hash[key] = []}
    # taxonomy_ids_per_d.each do |dataset_id, v_arr|
    #     taxonomy_per_d[dataset_id] << Taxonomy.where(id: v_arr)
    # end
    return taxonomy_per_d
  end

  def create_dat_seq_cnts(my_pdrs)
    dat_counts = Array.new
    
    # puts "my_pdrs = " + my_pdrs.inspect
    # URA1, my_pdrs = #<ActiveRecord::Relation [#<SequencePdrInfo id: 1001, dataset_id: 3, sequence_id: 1001, seq_count: 2, classifier: "GAST", created_at: "2013-08-19 13:04:05", updated_at: "2013-08-19 13:04:05">, #<SequencePdrInfo id: 1085, dataset_id: 3, sequence_id: 1002, seq_count: 103, classifier: "GAST", created_at: "2013-08-19 13:04:05", updated_at: "2013-08-19 13:04:05">, #<SequencePdrInfo id: 1414, dataset_id: 3, sequence_id: 1004, seq_count: 8, classifier: "GAST", created_at: "2013-08-19 13:04:05", updated_at: "2013-08-19 13:04:05">, #<SequencePdrInfo id: 1619, dataset_id: 3, sequence_id: 1005, seq_count: 203, classifier: "GAST", created_at: "2013-08-19 13:04:05", updated_at: "2013-08-19 13:04:05">, #<SequencePdrInfo id: 1908, dataset_id: 3, sequence_id: 1007, seq_count: 3, classifier: "GAST", created_at: "2013-08-19 13:04:05", updated_at: "2013-08-19 13:04:05">]>
    
    my_pdrs.each do |v|
      interm_hash = Hash.new
      interm_hash[:dataset_id]  = v.attributes["dataset_id"]
      interm_hash[:sequence_id] = v.attributes["sequence_id"]
      interm_hash[:seq_count]   = v.attributes["seq_count"]
      
      dat_counts << interm_hash
    end
    # dat_counts = [
    #     {"dataset_id"=>3, "sequence_id"=>1001, "seq_count"=>2},
    #     {"dataset_id"=>3, "sequence_id"=>1002, "seq_count"=>103},
    #     
    # end
    return dat_counts
  end

  
end
