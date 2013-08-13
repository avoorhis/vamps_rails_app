class SequencePdrInfo < ActiveRecord::Base
  belongs_to :sequence
  belongs_to :run_info
  
  validates :seq_count, numericality: { only_integer: true }
  
end
