class TaxaCount 

  RANKS_AMOUNT = Rank.where('rank != "NA"').size
  
  attr_accessor :taxa_count_per_d, :cnts_per_dataset_ids_by_tax_ids

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def create(taxonomies, dat_counts_seq)    
    tax_ids_hash      = create_tax_ids_hash(taxonomies)
    @taxa_count_per_d = add_dataset_ids(taxonomies, tax_ids_hash, dat_counts_seq)
  end
    
  def get_cnts_per_dataset_ids_by_tax_ids(tax_hash, tax_ids)
    puts "URA, tax_ids = " + tax_ids.inspect
    puts "URA, tax_hash = " + tax_hash.inspect
     tax_hash_temp = tax_hash
     (0...tax_ids.length).map {|i| tax_hash_temp = tax_hash_temp[tax_ids[i]]}
     @cnts_per_dataset_ids_by_tax_ids = tax_hash_temp[:datasets_ids]     
     puts "URA, @cnts_per_dataset_ids_by_tax_ids = " + @cnts_per_dataset_ids_by_tax_ids.inspect
     return @cnts_per_dataset_ids_by_tax_ids
  end

  private
  
  def create_tax_ids_hash(taxonomies)
    tax_ids_hash = Hash.recursive
    taxonomies.each do |tax_obj|
      t_vals = tax_obj.attributes.values
      tax_ids_hash[t_vals[1]][t_vals[2]][t_vals[3]][t_vals[4]][t_vals[5]][t_vals[6]][t_vals[7]][t_vals[8]] = {}
    end
    return tax_ids_hash
  end  
  
  def add_dataset_ids(taxonomies, tax_hash, dat_counts_seq)
   taxonomies.each do |tax_obj|
      dat_counts_seq_t = get_dat_counts_seq_by_t(tax_obj, dat_counts_seq)

      dat_counts_seq_t.each do |dat_cnt_seq_t|                
        (1..RANKS_AMOUNT).each do |n|
          add_dat_id_knt_to_tax_hash(tax_hash, tax_obj.attributes.values[1, n], dat_cnt_seq_t)
        end
      end      
    end
    return tax_hash
  end
  
  def add_dat_id_knt_to_tax_hash(tax_hash, taxon_str, dat_cnt_seq_t)
    tax_hash_temp = tax_hash
    for i in (0...taxon_str.length)
      # the last rank:
      if tax_hash_temp[taxon_str[i]][:datasets_ids].nil?
        tax_hash_temp[taxon_str[i]][:datasets_ids] = {}
      end
      if i == taxon_str.length - 1
        tax_hash_next                             = tax_hash_temp[taxon_str[i]][:datasets_ids]
        tax_hash_next[dat_cnt_seq_t[:dataset_id]] = get_knt(tax_hash_next, dat_cnt_seq_t)          
      end
      tax_hash_temp = tax_hash_temp[taxon_str[i]]      
    end
    tax_hash_temp    
  end
  
  def get_knt(tax_hash_next, dat_cnt_seq_t)  
    if tax_hash_next[dat_cnt_seq_t[:dataset_id]].is_a? Numeric
      knt = tax_hash_next[dat_cnt_seq_t[:dataset_id]] + dat_cnt_seq_t[:seq_count]
    else
      knt = dat_cnt_seq_t[:seq_count]
    end
    return knt
  end
  
  def get_dat_counts_seq_by_t(taxonomy_obj, dat_counts_seq)
    dat_counts_seq.select{|d| d[:taxonomy_id] == taxonomy_obj[:id]}
  end

end

class Hash
  def self.recursive
    new { |hash, key| hash[key] = recursive }
  end
end
