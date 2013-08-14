class RunInfo < ActiveRecord::Base
  belongs_to :dataset
  belongs_to :dna_region
  belongs_to :primer_suite
  belongs_to :run
  belongs_to :run_key

  has_many :sequence_pdr_infos
  has_many :sequences, :through => :sequence_pdr_info #do we need this?
  
  validates :overlap, inclusion: { in: ["complete", "partial", "none"],
      message: "%{value} is not a valid overlap" }
  
end
