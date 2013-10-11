module TaxaCountHelper
  def get_rank_names()
    ranks      = Rank.all.sorted 
    rank_names = []     
    ranks.map {|rank| rank.rank == "class" ? rank_names << "klass" : rank_names << rank.rank}
    rank_names.delete("NA")
    return rank_names
  end

  def get_seq_i()
    my_pdrs = SequencePdrInfo.where(dataset_id: params["dataset_ids"])

    seq_ids_n_cnt_per_d = Hash.new{|hash, key| hash[key] = {}}
    my_pdrs.each do |pdr|
        seq_ids_n_cnt_per_d[pdr.dataset_id][pdr.sequence_id] = pdr.seq_count
    end
    # puts "URA seq_ids_n_cnt_per_d =  " + seq_ids_n_cnt_per_d.inspect
    # seq_ids_n_cnt_per_d =  {2=>{1=>100, 2=>652436, 
    return seq_ids_n_cnt_per_d
  end

  def get_taxonomy_per_d()
    seq_ids_n_cnt_per_d     = get_seq_i()  
    uniq_seq_info_ids_per_d = get_uniq_seq_info_ids(seq_ids_n_cnt_per_d)
    taxonomy_ids_per_d      = get_taxonomy_ids_per_d(uniq_seq_info_ids_per_d)
    add_count_to_uniq_seq_info_ids_per_d(uniq_seq_info_ids_per_d, seq_ids_n_cnt_per_d)

    taxonomy_per_d          = Hash.new{|hash, key| hash[key] = []}
    taxonomy_ids_per_d.each do |dataset_id, v_arr|
        taxonomy_per_d[dataset_id] << Taxonomy.where(id: v_arr)
    end
    return taxonomy_per_d
  end

  
end
