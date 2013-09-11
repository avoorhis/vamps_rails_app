class RunInfo < ActiveRecord::Base
  belongs_to :dataset
  belongs_to :dna_region
  belongs_to :primer_suite
  belongs_to :run
  belongs_to :run_key

  has_one :project, :through => :dataset
  
  has_many :sequence_pdr_infos
  has_many :sequences, :through => :sequence_pdr_infos #do we need this?
  
  validates :overlap, inclusion: { in: ["complete", "partial", "none"], message: "%{value} is not a valid overlap" }
  validates_uniqueness_of :run_id, :scope => [:run_key_id, :barcode_index, :lane]
  
end
