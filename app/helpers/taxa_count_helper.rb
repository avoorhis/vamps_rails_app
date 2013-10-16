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
    #<ActiveRecord::Relation [#<Taxonomy id: 82, domain_id: 2, phylum_id: 3, klass_id: 3, order_id: 16, family_id: 18, genus_id: 129, species_id: 1, strain_id: 4, created_at: "2013-08-19 12:44:13", updated_at: "2013-08-19 12:44:13">, #<Taxonomy id: 96, domain_id: 2, phylum_id: 4, klass_id: 32, order_id: 5, family_id: 52, genus_id: 76, species_id: 1, strain_id: 4, created_at: "2013-08-19 12:44:13", updated_at: "2013-08-19 12:44:13">, #<Taxonomy id: 137, domain_id: 2, phylum_id: 3, klass_id: 5, order_id: 65, family_id: 129, genus_id: 129, species_id: 1, strain_id: 4, created_at: "2013-08-19 12:44:13", updated_at: "2013-08-19 12:44:13">]>
    # TODO: create taxonomy per dataset first? or keep tax_id and get dataset_id?
    # tax_dict = Hash.new{|hash, key| hash[key] = {}}
    # rank_id_names = make_rank_id_names()
    # puts "rank_id_names = " + rank_id_names.inspect
    # puts "rank_names = " + rank_names.inspect
    # rank_names = ["domain", "phylum", "klass", "order", "family", "genus", "species", "strain"]
    
    # tax_dict = Hash.recursive
    tax_dict = create_tax_dat_hash(taxonomies)
    puts "\nPPP: tax_dict = " + tax_dict.inspect
    
    tax_dict = add_dataset_ids(taxonomies, tax_dict, dat_counts_seq)
    # taxonomies.each do |t_o|
    #     arr_h = dat_counts_seq.select{|d| d[:taxonomy_id] == t_o[:id]}
    #     arr_h.each do |a|
    #       puts "arr_h = " + a.inspect
    #       if tax_dict[t_o[:domain_id]][:datasets_ids][a[:dataset_id]].nil?
    #         knt = a[:seq_count]
    #       else
    #       # puts 'tax_dict[t_o[:domain_id]][:datasets_ids][a[:dataset_id]] = ' + tax_dict[t_o[:domain_id]][:datasets_ids][a[:dataset_id]].inspect
    #         knt = tax_dict[t_o[:domain_id]][:datasets_ids][a[:dataset_id]] + a[:seq_count]
    #       end
    #       puts "a[:dataset_id] = #{a[:dataset_id].inspect}, knt = " + knt.inspect
    #       tax_dict[t_o[:domain_id]][:datasets_ids][a[:dataset_id]] = knt
    #     end
    # end
    puts "2) tax_dict = " + tax_dict.inspect
    # tax_dict = {2=>{:datasets_ids=>{3=>13, 4=>6}, 3=>{:datasets_ids=>{}, 3=>{:datasets_ids=>{}, 16=>{:datasets_ids=>{}, 18=>{:datasets_ids=>{}, 129=>{:datasets_ids=>{}, 1=>{:datasets_ids=>{}, 4=>{:datasets_ids=>{}}}}}}}, 5=>{:datasets_ids=>{}, 65=>{:datasets_ids=>{}, 129=>{:datasets_ids=>{}, 129=>{:datasets_ids=>{}, 1=>{:datasets_ids=>{}, 4=>{:datasets_ids=>{}}}}}}}}, 4=>{:datasets_ids=>{}, 32=>{:datasets_ids=>{}, 5=>{:datasets_ids=>{}, 52=>{:datasets_ids=>{}, 76=>{:datasets_ids=>{}, 1=>{:datasets_ids=>{}, 4=>{:datasets_ids=>{}}}}}}}}}}
    
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

  def create_tax_dat_hash(taxonomies)
    tax_dict = Hash.recursive
    taxonomies.each do |t|
      puts t.inspect
      my_arr = t.attributes.values
      puts "my_arr = " + my_arr.inspect

      tax_dict[my_arr[1]][my_arr[2]][my_arr[3]][my_arr[4]][my_arr[5]][my_arr[6]][my_arr[7]][my_arr[8]] = {}
      puts "tax_dict = " + tax_dict.inspect
    end
    return tax_dict
  end

  def add_dataset_ids(taxonomies, tax_dict, dat_counts_seq)
   puts "INSIDE: "
   puts "taxonomies" + taxonomies.inspect
   puts "\ntax_dict" + tax_dict.inspect
   puts "\ndat_counts_seq" + dat_counts_seq.inspect
   taxonomies.each do |t_o|
      arr_h = dat_counts_seq.select{|d| d[:taxonomy_id] == t_o[:id]}
      my_arr = t_o.attributes.values
      
      arr_h.each do |a|
        puts "-" * 10
        puts "\narr_h = " + a.inspect
        puts "\na[:dataset_id] = " + a[:dataset_id].inspect
        puts "\na[:seq_count] = " + a[:dataset_id].inspect
        puts "\nt_o[:id] = " + t_o[:id].inspect

          
        tax_dict_next = tax_dict[my_arr[1]][:datasets_ids]
        tax_dict_next[a[:dataset_id]] = get_knt(tax_dict_next, a)
        
        tax_dict_next = tax_dict[my_arr[1]][my_arr[2]][:datasets_ids]
        tax_dict_next[a[:dataset_id]] = get_knt(tax_dict_next, a)
      
      
        tax_dict_next = tax_dict[my_arr[1]][my_arr[2]][:datasets_ids]
				tax_dict_next[a[:dataset_id]] = get_knt(tax_dict_next, a)
        tax_dict_next = tax_dict[my_arr[1]][my_arr[2]][my_arr[3]][:datasets_ids]
				tax_dict_next[a[:dataset_id]] = get_knt(tax_dict_next, a)
        tax_dict_next = tax_dict[my_arr[1]][my_arr[2]][my_arr[3]][my_arr[4]][:datasets_ids]
				tax_dict_next[a[:dataset_id]] = get_knt(tax_dict_next, a)
        tax_dict_next = tax_dict[my_arr[1]][my_arr[2]][my_arr[3]][my_arr[4]][my_arr[5]][:datasets_ids]
				tax_dict_next[a[:dataset_id]] = get_knt(tax_dict_next, a)
        tax_dict_next = tax_dict[my_arr[1]][my_arr[2]][my_arr[3]][my_arr[4]][my_arr[5]][my_arr[6]][:datasets_ids]
				tax_dict_next[a[:dataset_id]] = get_knt(tax_dict_next, a)
        tax_dict_next = tax_dict[my_arr[1]][my_arr[2]][my_arr[3]][my_arr[4]][my_arr[5]][my_arr[6]][my_arr[7]][:datasets_ids]
				tax_dict_next[a[:dataset_id]] = get_knt(tax_dict_next, a)
        #         tax_dict_next = tax_dict[my_arr[1]][my_arr[2]][my_arr[3]][my_arr[4]][my_arr[5]][my_arr[6]][my_arr[7]][my_arr[8]][:datasets_ids]
        # tax_dict_next[a[:dataset_id]] = get_knt(tax_dict_next, a)
			end
      
    end
    puts "\ntax_dict RES = "  + tax_dict.inspect
    return tax_dict
  end
  
  def get_knt(tax_dict_next, a)  
    if tax_dict_next[a[:dataset_id]].is_a? Numeric
      puts 'tax_dict_next[a[:dataset_id]] = ' + tax_dict_next[a[:dataset_id]].inspect
      knt = tax_dict_next[a[:dataset_id]] + a[:seq_count]
    else
      knt = a[:seq_count]
    end
    return knt
  end
  
  def add_cnts_to_tax_dict(seq_count, tax_dict_next)
    puts "\nseq_count = #{seq_count.inspect},  tax_dict_next = "  + tax_dict_next.inspect
    
    if tax_dict_next.is_a? Numeric
      puts 'tax_dict_next = ' + tax_dict_next.inspect
      knt = tax_dict_next + seq_count
    else
      knt = seq_count
    end
    # puts "a[:dataset_id] = #{a[:dataset_id].inspect}, knt = " + knt.inspect
    tax_dict_next = knt    
  end
  
end

class Hash
  def self.recursive
    new { |hash, key| hash[key] = recursive }
  end
end
