class TaxaCount 

  attr_accessor :taxa_count_per_d, :taxonomies
  
  # validates_presence_of :taxonomies
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def create(taxonomies, tax_dict, dat_counts_seq)
    
    tax_ids_hash      = create_tax_ids_hash(taxonomies)
    @taxa_count_per_d = add_dataset_ids(taxonomies, tax_ids_hash, dat_counts_seq)
  end
  
  
  def get_tax_dict_by_tax_ids(tax_dict, tax_ids)
     d = Hash.recursive
     for i in (0...tax_ids.length)
       puts "\n-----\ni == #{i}"
       if i == tax_ids.length - 1
           puts "i == tax_ids.length - 1"
           # d[tax_ids[i]][:datasets_ids]
       end

       if i == 0
         puts "if i == 0"

         d = tax_dict[tax_ids[0]]
         puts "tax_ids[i] = " + tax_ids[i].inspect
         puts "1) d = " + d.inspect          
         next
       end

       puts "ELSE: tax_ids[i] = " + tax_ids[i].inspect
       puts "d[tax_ids[i]] = " + d[tax_ids[i]].inspect
       d = d[tax_ids[i]]
     end
     puts "d = " + d.inspect          
     d
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
  
  
  def add_dataset_ids(taxonomies, tax_dict, dat_counts_seq)
   puts "INSIDE: "
   puts "taxonomies" + taxonomies.inspect
   puts "\ntax_dict" + tax_dict.inspect
   puts "\ndat_counts_seq" + dat_counts_seq.inspect
   taxonomies.each do |t_o|
      dat_counts_seq_t = dat_counts_seq.select{|d| d[:taxonomy_id] == t_o[:id]}
      
      dat_counts_seq_t.each do |dat_cnt_seq_t|                
        (1..7).each do |n|
          add_dat_id_knt_to_tax_dict(tax_dict, t_o.attributes.values[1, n], dat_cnt_seq_t)
        end
			end      
    end
    puts "\ntax_dict RES = "  + tax_dict.inspect
    return tax_dict
  end
  
  def add_dat_id_knt_to_tax_dict(tax_dict, taxon_str, dat_cnt_seq_t)
    d = tax_dict
    for i in (0...taxon_str.length)
      if i == taxon_str.length - 1
        tax_dict_next = d[taxon_str[i]][:datasets_ids]
        tax_dict_next[dat_cnt_seq_t[:dataset_id]] = get_knt(tax_dict_next, dat_cnt_seq_t)          
      end
      d = d[taxon_str[i]]      
    end
    d    
  end
  
  def get_knt(tax_dict_next, dat_cnt_seq_t)  
    puts "FROM get_knt: tax_dict_next = " + tax_dict_next.inspect
    if tax_dict_next[dat_cnt_seq_t[:dataset_id]].is_a? Numeric
      # puts 'tax_dict_next[dat_cnt_seq_t[:dataset_id]] = ' + tax_dict_next[dat_cnt_seq_t[:dataset_id]].inspect
      knt = tax_dict_next[dat_cnt_seq_t[:dataset_id]] + dat_cnt_seq_t[:seq_count]
    else
      knt = dat_cnt_seq_t[:seq_count]
    end
    puts "dat_cnt_seq_t[:seq_count] = " + dat_cnt_seq_t[:seq_count].inspect
    puts "dat_cnt_seq_t[:dataset_id] = #{dat_cnt_seq_t[:dataset_id].inspect}, knt = " + knt.inspect
    return knt
  end
  


end

class Hash
  def self.recursive
    new { |hash, key| hash[key] = recursive }
  end
end
