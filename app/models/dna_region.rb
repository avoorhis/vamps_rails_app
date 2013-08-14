class DnaRegion < ActiveRecord::Base
  belongs_to :run_info
  validates :dna_region, uniqueness: true
    
end
