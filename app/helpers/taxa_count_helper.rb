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
  end

  def create_dat_seq_cnts(my_pdrs)
    dat_seq_cnts = Array.new
    
    my_pdrs.each do |v|
      # puts "HERE: v = " + v.inspect
      # puts "HERE:  v.sequence_uniq_info = " +  v.sequence_uniq_info.inspect
      # HERE:  v.sequence_uniq_info = #<SequenceUniqInfo id: 1001, sequence_id: 1001, taxonomy_id: 96, gast_distance: #<BigDecimal:103a8ee28,'0.0',9(18)>, refssu_id: 0, refssu_count: 1263, rank_id: 5, refhvr_ids: "v4v5_FT014", created_at: "2013-08-19 13:11:00", updated_at: "2013-08-19 13:11:00">
      
      interm_hash = Hash.new
      interm_hash[:dataset_id]  = v.dataset_id
      interm_hash[:sequence_id] = v.sequence_id
      interm_hash[:seq_count]   = v.seq_count
      interm_hash[:taxonomy_id] = v.sequence_uniq_info.taxonomy_id
      
      dat_seq_cnts << interm_hash
    end
    return dat_seq_cnts
  end

  def get_taxonomies(dat_counts_seq)
    tax_ids = dat_counts_seq.map{|i| i[:taxonomy_id]}
    Taxonomy.where(id: tax_ids.uniq)
  end
  
end

