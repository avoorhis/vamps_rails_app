class TaxaCount 

  attr_accessor :taxa_count_hash, :taxonomies
  
  # validates_presence_of :taxonomies
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def create(taxonomies)
    tax_dict = Hash.recursive
    taxonomies.each do |t|
      puts t.inspect
      t_vals = t.attributes.values
      puts "t_vals = " + t_vals.inspect
      tax_dict[t_vals[1]][t_vals[2]][t_vals[3]][t_vals[4]][t_vals[5]][t_vals[6]][t_vals[7]][t_vals[8]] = {}
      puts "tax_dict = " + tax_dict.inspect
    end
    @tax_dict = tax_dict
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
  # include ActiveModel::Validations
  # include ActiveModel::Conversion
  # extend  ActiveModel::Naming
  # 
  # attr_accessor :dataset_id, :sequence_id, :taxonomy_id, :count_per_d
  # 
  # validates_presence_of :dataset_id, :sequence_id, :taxonomy_id, :count_per_d
  # 
  # def initialize(attributes = {})
  #   attributes.each do |name, value|
  #     send("#{name}=", value)
  #   end
  # end
  # 
  # def persisted?
  #   false
  # end

  

end

class Hash
  def self.recursive
    new { |hash, key| hash[key] = recursive }
  end
end
