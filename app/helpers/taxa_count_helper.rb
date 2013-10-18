module TaxaCountHelper
  def get_rank_names()
    ranks      = Rank.all.sorted 
    rank_names = []     
    ranks.map {|rank| rank.rank == "class" ? rank_names << "klass" : rank_names << rank.rank}
    rank_names.delete("NA")
    return rank_names
  end

  def get_taxonomy_per_d(my_pdrs)
    dat_counts_seq = create_dat_seq_cnts(my_pdrs)  
    all_seq_ui     = get_all_sequence_uniq_infos(dat_counts_seq.map { |u| u[:sequence_id] })

    add_tax_id(dat_counts_seq, all_seq_ui)
    puts "URA3 = dat_counts_seq: " + dat_counts_seq.inspect
    
    taxonomies = get_taxonomies(dat_counts_seq)
    puts "\nHHH: taxonomies = " + taxonomies.inspect
    # TODO: create taxonomy per dataset first? or keep tax_id and get dataset_id?

    tax_hash_obj = TaxaCount.new
    tax_hash     = tax_hash_obj.create(taxonomies, tax_hash, dat_counts_seq)
    puts "\nPPP: tax_hash = " + tax_hash.inspect
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
    dat_seq_cnts = Array.new
    
    my_pdrs.each do |v|
      interm_hash = Hash.new
      interm_hash[:dataset_id]  = v.attributes["dataset_id"]
      interm_hash[:sequence_id] = v.attributes["sequence_id"]
      interm_hash[:seq_count]   = v.attributes["seq_count"]
      
      dat_seq_cnts << interm_hash
    end
    return dat_seq_cnts
  end

  def get_all_sequence_uniq_infos(seq_u_ids)
    SequenceUniqInfo.where(sequence_id: seq_u_ids)
  end

  def add_tax_id(dat_counts_seq, all_seq_ui)
    dat_counts_seq.each do |i|
      i[:taxonomy_id] = all_seq_ui.select {|u| u.attributes["sequence_id"] == i[:sequence_id]}.map{|a| a.attributes["taxonomy_id"]}[0]
    end
    return dat_counts_seq
  end

  def get_taxonomies(dat_counts_seq)
    tax_ids = dat_counts_seq.map{|i| i[:taxonomy_id]}.uniq
    Taxonomy.where(id: tax_ids)
  end
  
end

