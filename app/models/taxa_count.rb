class TaxaCount 

  RANKS_AMOUNT = Rank.where('rank != "NA"').size
  
  attr_accessor :taxa_count_per_d, :taxonomies, :cnts_per_dataset_ids_by_tax_ids

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def create(taxonomies, dat_counts_seq)    
    tax_ids_hash      = create_tax_ids_hash(taxonomies)
    @taxa_count_per_d = add_dataset_ids(taxonomies, tax_ids_hash, dat_counts_seq)
  end
    
  # not tested yet
  def get_cnts_per_dataset_ids_by_tax_ids(tax_hash, tax_ids)
     tax_hash_temp = tax_hash
     (0...tax_ids.length).map {|i| tax_hash_temp = tax_hash_temp[tax_ids[i]]}
     puts "RES1: tax_hash_temp[:datasets_ids] = " + tax_hash_temp[:datasets_ids].inspect  
     @datasets_ids_cnts = tax_hash_temp[:datasets_ids]     
  end

  private
  
  def create_tax_ids_hash(taxonomies)
    tax_ids_hash = Hash.recursive
    taxonomies.each do |t_o|
      t_vals = t_o.attributes.values
      tax_ids_hash[t_vals[1]][t_vals[2]][t_vals[3]][t_vals[4]][t_vals[5]][t_vals[6]][t_vals[7]][t_vals[8]] = {}
    end
    return tax_ids_hash
  end  
  
  def add_dataset_ids(taxonomies, tax_hash, dat_counts_seq)
   taxonomies.each do |t_o|
      dat_counts_seq_t = get_dat_counts_seq_by_t(t_o, dat_counts_seq)

      dat_counts_seq_t.each do |dat_cnt_seq_t|                
        # (1..RANKS_AMOUNT-1).each do |n|
        (1..RANKS_AMOUNT).each do |n|
          add_dat_id_knt_to_tax_hash(tax_hash, t_o.attributes.values[1, n], dat_cnt_seq_t)
        end
			end      
    end
    return tax_hash
  end
  
  def add_dat_id_knt_to_tax_hash(tax_hash, taxon_str, dat_cnt_seq_t)
    tax_hash_temp = tax_hash
    for i in (0...taxon_str.length)
      # puts "\n--------\nQQQ: i = " + i.to_s
      # puts "QQQ1: tax_hash = " + tax_hash.to_s
      # puts "QQQ2: taxon_str = " + taxon_str.to_s
      # puts "QQQ3: dat_cnt_seq_t = " + dat_cnt_seq_t.to_s
      # puts "QQQ4: tax_hash_temp[taxon_str[i]][:datasets_ids] = " + tax_hash_temp[taxon_str[i]][:datasets_ids].inspect
      # puts "QQQ5: tax_hash_temp[#{taxon_str[i]}][:datasets_ids] = " + tax_hash_temp[taxon_str[i]][:datasets_ids].inspect
      if tax_hash_temp[taxon_str[i]][:datasets_ids].nil?
        tax_hash_temp[taxon_str[i]][:datasets_ids] = {}
      end
      if i == taxon_str.length - 1
        tax_hash_next                             = tax_hash_temp[taxon_str[i]][:datasets_ids]
         # || {}
        # puts "QQQ5a: tax_hash_next = " + tax_hash_next.inspect
        
        tax_hash_next[dat_cnt_seq_t[:dataset_id]] = get_knt(tax_hash_next, dat_cnt_seq_t)          
      end
      tax_hash_temp = tax_hash_temp[taxon_str[i]]      
    end
    # puts "QQQ6: tax_hash_temp = " + tax_hash_temp.inspect
    
    tax_hash_temp    
  end
  
  def get_knt(tax_hash_next, dat_cnt_seq_t)  
    puts "\nKKK(get_knt): tax_hash_next = " + tax_hash_next.inspect
    puts "KKK1: dat_cnt_seq_t = " + dat_cnt_seq_t.to_s
    
    if tax_hash_next[dat_cnt_seq_t[:dataset_id]].is_a? Numeric
      knt = tax_hash_next[dat_cnt_seq_t[:dataset_id]] + dat_cnt_seq_t[:seq_count]
    else
      knt = dat_cnt_seq_t[:seq_count]
    end
    puts "KKK2: knt = " + knt.inspect
    return knt
  end
  
  def get_dat_counts_seq_by_t(t_o, dat_counts_seq)
    dat_counts_seq.select{|d| d[:taxonomy_id] == t_o[:id]}
  end

end

class Hash
  def self.recursive
    new { |hash, key| hash[key] = recursive }
  end
end
