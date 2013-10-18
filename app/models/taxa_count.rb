class TaxaCount 

  attr_accessor :taxa_count_per_d, :taxonomies
  
  # validates_presence_of :taxonomies
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def create(taxonomies, tax_hash, dat_counts_seq)
    
    tax_ids_hash      = create_tax_ids_hash(taxonomies)
    @taxa_count_per_d = add_dataset_ids(taxonomies, tax_ids_hash, dat_counts_seq)
  end
  
  
  def get_tax_hash_by_tax_ids(tax_hash, tax_ids)
     tax_has_temp = Hash.recursive
     for i in (0...tax_ids.length)
       puts "\n-----\ni == #{i}"
       if i == tax_ids.length - 1
           puts "i == tax_ids.length - 1"
           # tax_has_temp[tax_ids[i]][:datasets_ids]
       end

       if i == 0
         puts "if i == 0"

         tax_has_temp = tax_hash[tax_ids[0]]
         puts "tax_ids[i] = " + tax_ids[i].inspect
         puts "1) tax_has_temp = " + tax_has_temp.inspect          
         next
       end

       puts "ELSE: tax_ids[i] = " + tax_ids[i].inspect
       puts "tax_has_temp[tax_ids[i]] = " + tax_has_temp[tax_ids[i]].inspect
       tax_has_temp = tax_has_temp[tax_ids[i]]
     end
     puts "tax_has_temp = " + tax_has_temp.inspect          
     tax_has_temp
  end

  private
  
  def create_tax_ids_hash(taxonomies)
    tax_ids_hash = Hash.recursive
    taxonomies.each do |t|
      t_vals = t.attributes.values
      tax_ids_hash[t_vals[1]][t_vals[2]][t_vals[3]][t_vals[4]][t_vals[5]][t_vals[6]][t_vals[7]][t_vals[8]] = {}
    end
    return tax_ids_hash
  end
  
  
  def add_dataset_ids(taxonomies, tax_hash, dat_counts_seq)
   taxonomies.each do |t_o|
      dat_counts_seq_t = dat_counts_seq.select{|d| d[:taxonomy_id] == t_o[:id]}
      
      dat_counts_seq_t.each do |dat_cnt_seq_t|                
        (1..7).each do |n|
          add_dat_id_knt_to_tax_hash(tax_hash, t_o.attributes.values[1, n], dat_cnt_seq_t)
        end
			end      
    end
    return tax_hash
  end
  
  def add_dat_id_knt_to_tax_hash(tax_hash, taxon_str, dat_cnt_seq_t)
    tax_has_temp = tax_hash
    for i in (0...taxon_str.length)
      if i == taxon_str.length - 1
        tax_hash_next = tax_has_temp[taxon_str[i]][:datasets_ids]
        tax_hash_next[dat_cnt_seq_t[:dataset_id]] = get_knt(tax_hash_next, dat_cnt_seq_t)          
      end
      tax_has_temp = tax_has_temp[taxon_str[i]]      
    end
    tax_has_temp    
  end
  
  def get_knt(tax_hash_next, dat_cnt_seq_t)  
    if tax_hash_next[dat_cnt_seq_t[:dataset_id]].is_a? Numeric
      knt = tax_hash_next[dat_cnt_seq_t[:dataset_id]] + dat_cnt_seq_t[:seq_count]
    else
      knt = dat_cnt_seq_t[:seq_count]
    end
    return knt
  end
  


end

class Hash
  def self.recursive
    new { |hash, key| hash[key] = recursive }
  end
end
