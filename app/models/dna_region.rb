class DnaRegion < ActiveRecord::Base
  has_many  :run_infos
  validates :dna_region, uniqueness: true
    
end
