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
    puts "\nHHH: " + taxonomies.inspect
    #<ActiveRecord::Relation [#<Taxonomy id: 82, domain_id: 2, phylum_id: 3, klass_id: 3, order_id: 16, family_id: 18, genus_id: 129, species_id: 1, strain_id: 4, created_at: "2013-08-19 12:44:13", updated_at: "2013-08-19 12:44:13">, #<Taxonomy id: 96, domain_id: 2, phylum_id: 4, klass_id: 32, order_id: 5, family_id: 52, genus_id: 76, species_id: 1, strain_id: 4, created_at: "2013-08-19 12:44:13", updated_at: "2013-08-19 12:44:13">, #<Taxonomy id: 137, domain_id: 2, phylum_id: 3, klass_id: 5, order_id: 65, family_id: 129, genus_id: 129, species_id: 1, strain_id: 4, created_at: "2013-08-19 12:44:13", updated_at: "2013-08-19 12:44:13">]>
    # TODO: create taxonomy per dataset first? or keep tax_id and get dataset_id?
    tax_dict = Hash.new{|hash, key| hash[key] = {}}
    taxonomies.each do |t_o|
      tax_dict[t_o[:domain_id]][:datasets_ids] = {}
    end
    
    taxonomies.each do |t_o|
      tax_dict[t_o[:domain_id]][t_o[:phylum_id]] = {}
      tax_dict[t_o[:domain_id]][t_o[:phylum_id]][:datasets_ids] = {}      
      
    end
    taxonomies.each do |t_o|
      tax_dict[t_o[:domain_id]][t_o[:phylum_id]][t_o[:klass_id]] = {}
      tax_dict[t_o[:domain_id]][t_o[:phylum_id]][t_o[:klass_id]][:datasets_ids] = {}            
    end
    taxonomies.each do |t_o|
      tax_dict[t_o[:domain_id]][t_o[:phylum_id]][t_o[:klass_id]][t_o[:order_id]] = {}
      tax_dict[t_o[:domain_id]][t_o[:phylum_id]][t_o[:klass_id]][t_o[:order_id]][:datasets_ids] = {}      
    end
    taxonomies.each do |t_o|
      tax_dict[t_o[:domain_id]][t_o[:phylum_id]][t_o[:klass_id]][t_o[:order_id]][t_o[:family_id]] = {}
      tax_dict[t_o[:domain_id]][t_o[:phylum_id]][t_o[:klass_id]][t_o[:order_id]][t_o[:family_id]][:datasets_ids] = {}      
    end
    taxonomies.each do |t_o|
      tax_dict[t_o[:domain_id]][t_o[:phylum_id]][t_o[:klass_id]][t_o[:order_id]][t_o[:family_id]][t_o[:genus_id]] = {}
      tax_dict[t_o[:domain_id]][t_o[:phylum_id]][t_o[:klass_id]][t_o[:order_id]][t_o[:family_id]][t_o[:genus_id]][:datasets_ids] = {}      
    end
    taxonomies.each do |t_o|
      tax_dict[t_o[:domain_id]][t_o[:phylum_id]][t_o[:klass_id]][t_o[:order_id]][t_o[:family_id]][t_o[:genus_id]][t_o[:species_id]] = {}
      tax_dict[t_o[:domain_id]][t_o[:phylum_id]][t_o[:klass_id]][t_o[:order_id]][t_o[:family_id]][t_o[:genus_id]][t_o[:species_id]][:datasets_ids] = {}      
    end
    taxonomies.each do |t_o|
      tax_dict[t_o[:domain_id]][t_o[:phylum_id]][t_o[:klass_id]][t_o[:order_id]][t_o[:family_id]][t_o[:genus_id]][t_o[:species_id]][t_o[:strain_id]] = {}
      tax_dict[t_o[:domain_id]][t_o[:phylum_id]][t_o[:klass_id]][t_o[:order_id]][t_o[:family_id]][t_o[:genus_id]][t_o[:species_id]][t_o[:strain_id]][:datasets_ids] = {}      
    end
    puts "\nPPP: " + tax_dict.inspect
    
    # a = dat_counts_seq.group_by{|i| i[:dataset_id]}
    # .map {|i| i[:taxonomy_id]}
    # tax_ids = dat_counts_seq.map{|i| i[:taxonomy_id]}.uniq
    # taxonomies = Taxonomy.where(id: tax_ids)
    # res = t_arr.group_by {|t| t.join(";")}.map{|k,v| [k, v.length]}

    # dat_counts_seq.each do |h|
    #   all_t_strings[]
    # end
    
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
