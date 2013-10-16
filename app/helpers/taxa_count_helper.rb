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
    rank_id_names = make_rank_id_names()
    puts "rank_id_names = " + rank_id_names.inspect
    # puts "rank_names = " + rank_names.inspect
    # rank_names = ["domain", "phylum", "klass", "order", "family", "genus", "species", "strain"]
    
    tax_dict = Hash.recursive
    create_tax_dat_hash(taxonomies)
      # (0...rank_id_names.length).each do |a|
      #   puts "a = " + a.inspect
      # end
    
    # taxonomies.each do |t_o|
    #   tax_dict[t_o[:domain_id]][:datasets_ids] = {}
    # end
    # 
    # taxonomies.each do |t_o|
    #   tax_dict[t_o[:domain_id]][t_o[:phylum_id]] = {}
    #   tax_dict[t_o[:domain_id]][t_o[:phylum_id]][:datasets_ids] = {}      
    #   
    # end
    # taxonomies.each do |t_o|
    #   tax_dict[t_o[:domain_id]][t_o[:phylum_id]][t_o[:klass_id]] = {}
    #   tax_dict[t_o[:domain_id]][t_o[:phylum_id]][t_o[:klass_id]][:datasets_ids] = {}            
    # end
    # taxonomies.each do |t_o|
    #   tax_dict[t_o[:domain_id]][t_o[:phylum_id]][t_o[:klass_id]][t_o[:order_id]] = {}
    #   tax_dict[t_o[:domain_id]][t_o[:phylum_id]][t_o[:klass_id]][t_o[:order_id]][:datasets_ids] = {}      
    # end
    # taxonomies.each do |t_o|
    #   tax_dict[t_o[:domain_id]][t_o[:phylum_id]][t_o[:klass_id]][t_o[:order_id]][t_o[:family_id]] = {}
    #   tax_dict[t_o[:domain_id]][t_o[:phylum_id]][t_o[:klass_id]][t_o[:order_id]][t_o[:family_id]][:datasets_ids] = {}      
    # end
    # taxonomies.each do |t_o|
    #   tax_dict[t_o[:domain_id]][t_o[:phylum_id]][t_o[:klass_id]][t_o[:order_id]][t_o[:family_id]][t_o[:genus_id]] = {}
    #   tax_dict[t_o[:domain_id]][t_o[:phylum_id]][t_o[:klass_id]][t_o[:order_id]][t_o[:family_id]][t_o[:genus_id]][:datasets_ids] = {}      
    # end
    # taxonomies.each do |t_o|
    #   tax_dict[t_o[:domain_id]][t_o[:phylum_id]][t_o[:klass_id]][t_o[:order_id]][t_o[:family_id]][t_o[:genus_id]][t_o[:species_id]] = {}
    #   tax_dict[t_o[:domain_id]][t_o[:phylum_id]][t_o[:klass_id]][t_o[:order_id]][t_o[:family_id]][t_o[:genus_id]][t_o[:species_id]][:datasets_ids] = {}      
    # end
    # taxonomies.each do |t_o|
    #   tax_dict[t_o[:domain_id]][t_o[:phylum_id]][t_o[:klass_id]][t_o[:order_id]][t_o[:family_id]][t_o[:genus_id]][t_o[:species_id]][t_o[:strain_id]] = {}
    #   tax_dict[t_o[:domain_id]][t_o[:phylum_id]][t_o[:klass_id]][t_o[:order_id]][t_o[:family_id]][t_o[:genus_id]][t_o[:species_id]][t_o[:strain_id]][:datasets_ids] = {}      
    # end
    puts "\nPPP: tax_dict = " + tax_dict.inspect

    taxonomies.each do |t_o|
        arr_h = dat_counts_seq.select{|d| d[:taxonomy_id] == t_o[:id]}
        arr_h.each do |a|
          puts "arr_h = " + a.inspect
          if tax_dict[t_o[:domain_id]][:datasets_ids][a[:dataset_id]].nil?
            knt = a[:seq_count]
          else
          # puts 'tax_dict[t_o[:domain_id]][:datasets_ids][a[:dataset_id]] = ' + tax_dict[t_o[:domain_id]][:datasets_ids][a[:dataset_id]].inspect
            knt = tax_dict[t_o[:domain_id]][:datasets_ids][a[:dataset_id]] + a[:seq_count]
          end
          puts "a[:dataset_id] = #{a[:dataset_id].inspect}, knt = " + knt.inspect
          tax_dict[t_o[:domain_id]][:datasets_ids][a[:dataset_id]] = knt
        end
    end
    puts "tax_dict = " + tax_dict.inspect
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

  def make_rank_id_names() 
    rank_names    = get_rank_names()
    rank_id_names = Array.new
    rank_names.map{|r| rni = r.to_s + "_id"; rank_id_names << rni.to_sym}
    # puts "rank_id_names = " + rank_id_names.inspect
    # puts rank_id_names.length
    # puts "\n" + "*" * 8
    return rank_id_names
  end

  # def create_tax_dat_hash(taxonomies, rank_id_names)
  #    tax_dict  = Hash.recursive
  #    rank_id_names.each do |rank_id_name|
  #      temp_dict = Hash.new
  #      taxonomies.each do |t_o|
  #        temp_dict[t_o[rank_id_name]] = {}
  #        temp_dict[t_o[rank_id_name]][:datasets_ids] = {}
  #        puts "temp_dict = " + temp_dict.inspect
  #      end
  #      # tax_dict = {value => tempHash}
  #      
  #    end
  #  end
  #  # taxonomies.each do |t_o|
  #  #   tax_dict[t_o[:domain_id]][t_o[:phylum_id]] = {}
  #  #   tax_dict[t_o[:domain_id]][t_o[:phylum_id]][:datasets_ids] = {}      
  #  #   
  #  # end
  #  
  def create_tax_dat_hash(taxonomies)
    tax_dict = Hash.recursive
    taxonomies.each do |t|
      puts t.inspect
      my_arr = []
      t.attributes.each do |attr_name, attr_value|
        my_arr << attr_value
      end
      puts my_arr

      tax_dict[my_arr[1]][my_arr[2]][my_arr[3]][my_arr[4]][my_arr[5]][my_arr[6]][my_arr[7]][my_arr[8]] = {}
      puts "tax_dict = " + tax_dict.inspect
    end
  end
end

class Hash
  def self.recursive
    new { |hash, key| hash[key] = recursive }
  end
end
